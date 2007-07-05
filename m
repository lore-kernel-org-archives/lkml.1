Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbXGILSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbXGILSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 07:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbXGILSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 07:18:43 -0400
Received: from mail.tmr.com ([64.65.253.246]:34742 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbXGILSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 07:18:42 -0400
Message-ID: <468D6C95.4070008@tmr.com>
Date: Thu, 05 Jul 2007 18:11:33 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: speed trends in pata world.
References: <200707041550.22533.gene.heskett@gmail.com>
In-Reply-To: <200707041550.22533.gene.heskett@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> Greetings;
> 
> The drive speeds seem to be going the wrong way.  Its an nforce2 equipt mobo, 
> and I have 3 drives currently in this box.  Running 2.6.22-rc6-cfs-v18 + the 
> ftdi_sio.c patch.
> 
> hda, the primary on cable 0, is running at around 28MB/Sec.  Its a 200GB WD 
> about 2 years old.
> 
> hdb, is running at around 79MB/Sec, its a 4 year old 120GB WD.
> hdd is running at about 75MB/Sec, is a nearly new 300GB WD.
> 
> Can I read anything into the fact that the 2 fast drives are on the slave end 
> of the cables, whereas the slow one is master in the middle of the cable?
> 
First look at dmesg and see what it tells you. Second, if there is a 
slow device on the cable it will sometimes limit the speed of the disk. 
Alan Cox and God might know why, I don't.

Third, you can play with drive parameters with hdparm. *DANGEROUS* to do 
so, the man page says "needless and risky," but at least the older 
kernels truly sucked at guessing the correct speeds. Backups are advised 
if you do this, etc,etc.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
