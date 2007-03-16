Return-Path: <linux-kernel-owner+w=401wt.eu-S964793AbXCPXb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964793AbXCPXb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 19:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965997AbXCPXb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 19:31:57 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:55489 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964793AbXCPXb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 19:31:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kN+FWHRWe8ccXF/bNFbp27IBwrAf6J8M3obJVib3q0SUVp7n0rach06KBo9xYLsiyvwsRveYCuZ3/MvTKRqiQh6y2HSkXZ6EtIy5xBlffPOWUlka9F8K+wIFTfd0/nTg4Xafh8satlhTEVwxeyivJjW5NJiEEuhDLcLfcGI2S4M=
Message-ID: <6bffcb0e0703161631s1a75ededya887dd756e6f33b6@mail.gmail.com>
Date: Sat, 17 Mar 2007 00:31:54 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Subject: Re: Linux 2.6.21-rc4
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Takashi Iwai" <tiwai@suse.de>
In-Reply-To: <Pine.LNX.4.61.0703170022200.23117@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <45FAD77A.1070709@googlemail.com>
	 <20070316102650.267e2c55.akpm@linux-foundation.org>
	 <6bffcb0e0703161155o1e153725jd3f4a01fb5fa0d55@mail.gmail.com>
	 <Pine.LNX.4.61.0703170022200.23117@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/03/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
>
> On Mar 16 2007 19:55, Michal Piotrowski wrote:
> >> > I've got *bad* news. Bug described here
> >> > http: //www.ussg.iu.edu/hypermail/linux/kernel/0703.0/index.html#0889
> >> > http: //www.ussg.iu.edu/hypermail/linux/kernel/0703.0/index.html#1165
> >> > probably leaked into mainline.
> >> >
> >> > Fsck!
> >>
> >> fsck indeed.  I don't even understand what's happening with that one - it
> >> seems like the kernel schedules a user process, but never deschedules it
> >> again.
> >>
> >
> > Tomorrow, I'll try to find out how to reproduce this bug.
>
> From #0889:
>
>  "I have noticed some strange system behavior. When i try to build a
>  kernel (medium load) - X, keyboard, mouse and sound hangs."
>
> Note that ping is handled in interrupt or softirq context. So something has
> locked up. Try without X? Or perhaps attack a serial console/netconsole, and
> when it hangs, use Sysrq to dump the process' states.

I already did this
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc4/git-console.log

>
>
> Jan
> --
>

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
