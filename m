Return-Path: <linux-kernel-owner+w=401wt.eu-S2992911AbXDDO52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992911AbXDDO52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 10:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992916AbXDDO52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 10:57:28 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:42683 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992911AbXDDO51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 10:57:27 -0400
Date: Wed, 4 Apr 2007 16:57:26 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Rene Herman <rene.herman@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
Message-ID: <20070404145726.GD27660@stusta.de>
References: <46138B4C.2050409@gmail.com> <20070404123311.GA18552@infradead.org> <4613A1F1.2080007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4613A1F1.2080007@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 03:02:41PM +0200, Rene Herman wrote:
> On 04/04/2007 02:33 PM, Christoph Hellwig wrote:
> 
> >On Wed, Apr 04, 2007 at 01:26:04PM +0200, Rene Herman wrote:
> 
> >>Can we have a MODULE_MAINTAINER to complement MODULE_AUTHOR?
> >
> >#define MODULE_MAINTAINER(x) MODULE_AUTHOR(x), please.
> >MODULE_AUTHOR really has meant maintainer in practice for ages, and it's
> >the only actually relevant for users information we should store.
> 
> Given modules with multiple authors, current and non-current, I believe 
> having "modinfo -m" tell the user whom to contact is an avantage.

Much bigger problems are:
- Who will maintain this information properly?
- What about modules that are maintained implicitely by the subsystem
  maintainer?

And often a user can't be expected to locate the source of a problem, or 
it might not be in a driver but in a subsystem.

For vendor kernels, the user should contact the vendor.
For ftp.kernel.org kernels, I don't see any better solution than telling 
people to report problems to linux-kernel or the kernel Bugzilla and 
routing them further from here.

> Rene.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

