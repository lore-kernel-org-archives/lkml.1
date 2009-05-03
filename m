Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbZECBsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbZECBsO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 21:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbZECBrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 21:47:55 -0400
Received: from mail001.aei.ca ([206.123.6.130]:35033 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbZECBry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 21:47:54 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: 2.6.30-rc4: xfs_fsr hangs
Date: Sat, 2 May 2009 21:47:51 -0400
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-crc; KDE/4.2.2; x86_64; ; )
Cc: Alexander Beregalov <a.beregalov@gmail.com>, linux-kernel@vger.kernel.org,
       Heinz Diehl <htd@fancy-poultry.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>, xfs@oss.sgi.com
References: <a4423d670905011333s664115bdh1d72392897567c1d@mail.gmail.com> <a4423d670905021159k51e91b12h96189005980b5e73@mail.gmail.com> <49FCA988.2050600@sandeen.net>
In-Reply-To: <49FCA988.2050600@sandeen.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905022147.52216.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 May 2009 16:14:00 Eric Sandeen wrote:
> Alexander Beregalov wrote:
> > 2009/5/2 Eric Sandeen <sandeen@sandeen.net>:
> >> Alexander Beregalov wrote:
> >>> 2009/5/2 Heinz Diehl <htd@fancy-poultry.org>:
> >>>> On 01.05.2009, Alexander Beregalov wrote:
> >>>>
> >>>>> # xfs_db -r /dev/sdc1
> >>>>> xfs_db> frag
> >>>>> actual 23805, ideal 22890, fragmentation factor 3.84%
> >>>>> # xfs_fsr -v /dev/sdc1
> >>>>> /mnt/c start inode=0
> >>>>> ino=158
> >>>>> extents before:3 after:1 DONE ino=158
> >>>>>
> >>>>>  then it hangs
> >>>> I can't confirm this here on my systems:
> >>>>
> >>>> liesel:~ # uname -a
> >>>> Linux liesel 2.6.30-rc4 #1 SMP PREEMPT Sat May 2 11:49:13 CEST 2009 x86_64 x86_64 x86_64 GNU/Linux
> >>> I have this problem on two x86_32 hosts.
> >>> It runs for about a minute and then hangs.
> >> echo w > /proc/sysrq-trigger
> >> dmesg
> >>
> >> would show all the sleeping processes...
> > It is the same as I posted already:
> 
> hum, only 1 thread, interesting...
 
I have also had strange stalls with rc4 (but not with rc3).  In one case sysrq would just print the title of commands no
data would follow.  Do not know if this is related but it may be that this is not just an xfs issue.

Ed Tomlinson
