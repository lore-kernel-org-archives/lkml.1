Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbXDDTNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbXDDTNE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 15:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbXDDTNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 15:13:04 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:42974 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753908AbXDDTNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 15:13:00 -0400
Date: Wed, 4 Apr 2007 21:12:59 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Rene Herman <rene.herman@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
Message-ID: <20070404191258.GR27660@stusta.de>
References: <46138B4C.2050409@gmail.com> <20070404123311.GA18552@infradead.org> <1175698135.5815.447.camel@violet> <20070404150231.GE27660@stusta.de> <4613C963.6070409@gmail.com> <20070404170016.453d26f1@the-village.bc.nu> <4613D492.2070404@gmail.com> <s5hps6kxefx.wl%tiwai@suse.de> <20070404174839.GQ27660@stusta.de> <4613E7FB.20601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4613E7FB.20601@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 08:01:31PM +0200, Rene Herman wrote:
> On 04/04/2007 07:48 PM, Adrian Bunk wrote:
> 
> >On Wed, Apr 04, 2007 at 07:00:18PM +0200, Takashi Iwai wrote:
> 
> >>But in general, it would be nice to have an easy way to find a
> >>maintainer (not author) from a module binary, and I agree
> >>MODULE_MAINTAINER can work well for such a purpose.  It's no mandatory
> >>field, but could be some help.
> >
> >Yes, it would be nice.
> >
> >But would this information always be kept up-to-date for the whole tree?
> >I don't see this happen.
> 
> I believe it would largely stay up to date yes. The tag wouldn't be 
> mandatory and adding oneself as a MODULE_MAINTAINER would specifically 
> be saying "yes, I want to look after this thing". If someone then no 
> longer wants to, getting rid of the tag is a matter of deleting one 
> line. I wouldn't be worse than MAINTAINERS, and being inline, I expect 
> it to be better...

- often module maintainers disappear suddenly or slowly without any
  clear statement that maintainership ended
- most drivers are not maintained on a per-driver but on a per-subsystem
  basis

Consider that we don't even manage to keep MAINTAINERS correct, and 
consider that we are talking about more than 2800 modules.

Realistically, users should report problems with vendor kernels to the 
vendor and problems with ftp.kernel.org kernels to either linux-kernel 
or the kernel Bugzilla, and forwarding issues to the responsible people 
(if any) should be done there [1].

> Rene.

cu
Adrian

[1] Andrew is doing this

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

