Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbXITMxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbXITMxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 08:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461AbXITMxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 08:53:10 -0400
Received: from mail.sousedi.net ([85.132.167.140]:43906 "EHLO mail.sousedi.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755369AbXITMxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 08:53:07 -0400
Message-ID: <46F26D19.3010605@prepere.com>
Date: Thu, 20 Sep 2007 14:52:41 +0200
From: majkls <majkls@prepere.com>
User-Agent: IceDove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Philipp Marek <philipp@marek.priv.at>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       david@davidnewall.com, davidsen@tmr.com, bunk@fs.tum.de
Subject: Re: sys_chroot+sys_fchdir Fix
References: <952DN-83o-31@gated-at.bofh.it> <954cl-29C-3@gated-at.bofh.it>    <95ctn-74b-15@gated-at.bofh.it> <95cMH-7um-19@gated-at.bofh.it>    <95gdA-4OZ-7@gated-at.bofh.it> <E1IYJyC-0000iq-TR@be1.lrz> <56705.193.171.152.61.1190289559.squirrel@webmail.marek.priv.at>
In-Reply-To: <56705.193.171.152.61.1190289559.squirrel@webmail.marek.priv.at>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Philipp Marek napsal(a):
> Please, everybody,
>
> don't change that.
>
> I'm currently using that *feature* (yes, I see it as that) in my
> fsvs-chrooter-utility (see
> http://fsvs.tigris.org/source/browse/*checkout*/fsvs/trunk/www/doxygen/html/group__howto__chroot.html)
> for easier usage of fsvs on older systems.
>
> - User starts a small wrapper,
> - that opens "/",
> - chroot()s into a directory and starts fsvs.
> - fsvs gets its libraries loaded
> - and chroot()s back to the original system.
>
> Voila! fsvs can use the newest available libraries for that architecture,
> without having to change the installed system.
>
>   
So I thing this is an example how chroot would not be really used. For 
DSO loading there is many better ways to load own DSO. Though is this 
feature described in chroot() manpage, I have not noticed that any 
serious project uses it.  But ok, this is a ferature of chroot(). Also 
FreeBSD does not support escaping chroot AFAIK. So this feature is very 
badly portable.


Miloslav
