Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbZEBKK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbZEBKK2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 06:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZEBKKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 06:10:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53288 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbZEBKKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 06:10:13 -0400
Date: Sat, 2 May 2009 12:14:05 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 2.6.30-rc4: xfs_fsr hangs
Message-ID: <20090502101405.GA6145@fancy-poultry.org>
Reply-To: linux-kernel@vger.kernel.org
References: <a4423d670905011333s664115bdh1d72392897567c1d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670905011333s664115bdh1d72392897567c1d@mail.gmail.com>
Organization: private site
User-Agent: Mutt/1.5.19+20090405 (GNU/Linux)
X-Provags-ID: V01U2FsdGVkX19cgp2K9Ko3pvHs3Q2/qyDAw8E8TAQA2ZAnuqk
 V4dZi3Wnxj8XpH5VIwvNtdjWkuHgMY1MWV+mafU7R/smfZKSXE
 uvz1NilNy2sgzRg9kfiPTNRxtqflRFh
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.05.2009, Alexander Beregalov wrote: 

> # xfs_db -r /dev/sdc1
> xfs_db> frag
> actual 23805, ideal 22890, fragmentation factor 3.84%
> # xfs_fsr -v /dev/sdc1
> /mnt/c start inode=0
> ino=158
> extents before:3 after:1 DONE ino=158
> 
>  then it hangs

I can't confirm this here on my systems:

liesel:~ # uname -a
Linux liesel 2.6.30-rc4 #1 SMP PREEMPT Sat May 2 11:49:13 CEST 2009 x86_64 x86_64 x86_64 GNU/Linux

liesel:~ # xfs_db -r /dev/sdc1
xfs_db> frag
actual 42974, ideal 42842, fragmentation factor 0.31%
xfs_db> quit

liesel:~ # xfs_fsr -v /dev/sdc1
/home start inode=0
ino=248755507
ino=248755507 already fully defragmented.
ino=536871160
extents before:2 after:1 DONE ino=536871160
ino=536875693
extents before:3 after:1 DONE ino=536875693
ino=615920545
extents before:2 after:1 DONE ino=615920545
ino=615920557
extents before:2 after:1 DONE ino=615920557
ino=1092324584
extents before:4 after:1 DONE ino=1092324584
liesel:~ #

