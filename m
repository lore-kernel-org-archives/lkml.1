Return-Path: <linux-kernel-owner+w=401wt.eu-S1753799AbXLHO2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbXLHO2m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 09:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbXLHO2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 09:28:34 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60981 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751219AbXLHO2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 09:28:34 -0500
Date: Sat, 8 Dec 2007 15:28:31 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Tejun Heo <htejun@gmail.com>
Cc: sam@ravnborg.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       notting@redhat.com, rusty@rustcorp.com.au, kay.sievers@vrfy.org,
       greg@kroah.com
Subject: Re: [PATCH] kbuild: implement modules.order
Message-ID: <20071208142831.GB20441@stusta.de>
References: <47555AF1.8090304@gmail.com> <20071207174843.GA20441@stusta.de> <4759DE63.7010206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4759DE63.7010206@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 08:59:31AM +0900, Tejun Heo wrote:
> Adrian Bunk wrote:
> > On Tue, Dec 04, 2007 at 10:49:37PM +0900, Tejun Heo wrote:
> >> When multiple built-in modules (especially drivers) provide the same
> >> capability, they're prioritized by link order specified by the order
> >> listed in Makefile.  This implicit ordering is lost for loadable
> >> modules.
> >> ...
> > 
> > What exactly are the drivers you are thinking of?
> > 
> > I would rather see us getting away from any link order dependencies.
> > 
> > E.g. we might one day want to compile the whole kernel with one gcc call 
> > (using "--combine -fwhole-program").
> 
> The following bugzilla triggered this change and I think contains enough
> discussion on the subject.
> 
>   http://bugzilla.kernel.org/show_bug.cgi?id=8933
> 
> Thanks.

Thanks, that explains much.

And thinking about it, it doesn't seem to add any problems regarding 
what I have in mind:

If we would ever stop having any well-defined link-order for in-kernel 
code and express everything through initcall levels, we simply must 
additionally update the modules.order file.

> tejun

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

