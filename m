Return-Path: <linux-kernel-owner+w=401wt.eu-S965964AbXCFRKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965964AbXCFRKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 12:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965969AbXCFRKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 12:10:39 -0500
Received: from mail.tmr.com ([64.65.253.246]:58859 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965964AbXCFRKh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 12:10:37 -0500
Message-ID: <45EDA108.2000305@tmr.com>
Date: Tue, 06 Mar 2007 12:12:40 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: devzero@web.de
CC: linux-kernel@vger.kernel.org, greg@kroah.com, pavel@suse.cz
Subject: Re: [RFC] BadRAM still not ready for inclusion ? (was: Re: Free Linux
 Driver Development!)
References: <1663310550@web.de>
In-Reply-To: <1663310550@web.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

telling youdevzero@web.de wrote:
> Hello !
> 
> There's some really nice feature-patch named BadRAM at
http://rick.vanrein.org/linux/badram/index.html for years now, being
announced around 2000 on this list, voted for inclusion in 2.3.99.
> 
> BadRAM let's you tell the kernel to skip certain regions of ram, so
you can continue using defective modules. Some older article describing
BadRAM in more detail is at http://www.linuxjournal.com/article/4489

	[...snip...]
> 
> Basically, this feature is a matter of adding/modifying 200 lines of
code, so i´m even more wondering, why it exists for more than 7 years
and nothing happening here. I don`t know of any kernel patch which is
comparable to this.
> 
Think about that... 200 lines of code which will have to be maintained 
forever, once it becomes a supported feature, for the benefit of the few 
people who can't or won't replace bad memory.

> This patch is real a ressource-saver - if being a standard Linux
feature, it will save even more ressources: Saving user's time (because
they are pulling their hair out to get this run with kernel XYZ) and
also saving CPU time (no compile orgies anymore), and thus waste of energy.
> 
Consider one technical and one human behavour issue. While memory with 
"bad spots" was common a decade ago, it's as likely with current memory 
that the memory will "throw a bad bit" once in a while, on a read or 
write anywhere in the marginal or bad chip. Depending on how the memory 
is organized that could be 1/16th of the memory as a block of 32MB on a 
512MB part, or every 16th byte in the whole memory.

As for the human issue, how many more people will use this capability to 
avoid buying memory, run with only part of the bad memory detected and 
blocked out, get unreliable operation, and think that Linux is unreliable.

> Please comment if someone sees chances of getting this (after years
> of
existance) into mainline and also please jump in to make the good thing
happen !
> 
I personally think that the patch is at best a balance between benefit 
and problems. As a patch I have to use deliberately I think it's a good 
idea. As a permanent and default part of the kernel, I'm not convinced. 
There are some patches I would love to see in mainline, like suspend2 
which includes resume as well as suspend, but this is not one of them, 
hope I've explained why.

As with so many other things in life, "it's not the cost but the upkeep."

> Historical patch collection at:
> http://rick.vanrein.org/linux/badram/download.html
> 
> Most recent version of BadRAM should be:
> http://rick.vanrein.org/linux/badram/software/BadRAM-2.6.19.1.patch
> 
> Sorry for being a little bit "noisy" here, but I think BadRAM is a
great feature and Linux could really benefit from that.
> 
> regards
> Roland K.
> Sysadmin
> 
> 
> List:       linux-kernel
> Subject:    Re: Free Linux Driver Development!
> From:       devzero () web ! de
> Date:       2007-02-04 21:37:33
> Message-ID: 1605445807 () web ! de
> [Download message RAW]
> 
> First off, compliments to this announcement, I liked it very much!
> 
> Some comment regarding those "volunteers, waiting to get some real work" :)
> 
>>> OK, but why isn't your army of volunteers fixing them?
> 
>> They don't know about them, or they don't have the hardware to test?
>> Seriously, let the kernel-janitor's project know about any issues you
>> have and they will be glad to jump on it.  Those people are just
>> chomping a the bit to do something a bit bigger than "compiler warning
>> cleanups" :)
> 
> So many times i have seen good ideas brought up, kernel patches being written, posted \
> to lkml, being developed outside mainline for a while and then being forgotten some \
> time later due to lack of energy of some individual to get this into mainline.
> 
> If there is an noticeably number of talented programmers (unfortunately, i`m not) , \
> so why not "feeding" them the right way ? Where is those public and transparent and \
> moderated Linux-Kernel "ToDo"- or "Keep an eye on"-list, sorted by priorities, with \
> sort of a "vote for this feature"-button, so those guys have something they can pick \
> up? There is so much great stuff and ideas out there where they could put their work \
> onto or getting involved, it just needs to be found or sort of being "managed" a \
> little bit better.
> 
> For myself, i`m waiting for so quite some things to get "one step further", but they \
> are more or less tied to some single individuals, for which you just cannot send some \
> "hey, what`s up with your project"-message every second day. The interest in many \
> nice projects often is quite low and evolution quite slow, but not only because of \
> the fact that they aren`t great, but more because of not getting widely known. It`s \
> not always missing specs, it`s also some missing noise/feedback for different \
> features or missing of some "driving force" to bring things forward. How should one \
> developer know that somebody needs a feature if those who could probably need it \
> don`t request it? Maybe just because of the fact that they even imagine that such \
> feature would be possible ?
> 
> Where is those efforts for fixing/integrating fantastic cowloop?
> What about badram/badmem patch ?
> Compressed Ccaching ?
> Somebody helping with development of dm-loop or extend loop.c to support more than \
> 256 devices ? Replacement of proprietary, unstable and unelegant vmware-lopp for \
> being able to mount vmware .vmdk files ? Internal Spec for this is open, dm-userspace \
> could be some infrastructure for this, but the author seems to have other \
> priorities.... dm-cow, zfs-fuse - anybody ?
> Kernel based target for AoE (Ata over Ethernet) ?  (there are two independent \
> implementations, but both got stuck at some early experimental stage) 
> 
> Just my 2 cents. 
> 
> Roland K.
> Sysadmin
> 
> ps:
> This isn`t meant to criticise any of you kernel developers since you`re doing \
> fantastic work!
> _______________________________________________________________________
> Viren-Scan für Ihren PC! Jetzt für jeden. Sofort, online und kostenlos.
> Gleich testen! http://www.pc-sicherheit.web.de/freescan/?mc=022222
> 


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

