Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbZL3UpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbZL3UpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 15:45:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbZL3UpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 15:45:01 -0500
Received: from mailout.uni-giessen.de ([134.176.2.3]:40667 "EHLO
	merkurneu.hrz.uni-giessen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753204AbZL3UpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 15:45:00 -0500
From: Marvin <marvin24@gmx.de>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: vfs related crash in 2.6.33-rc2
Date: Wed, 30 Dec 2009 21:44:36 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc2; KDE/4.3.4; x86_64; ; )
References: <200912301733.19077.marvin24@gmx.de> <87637oi6v8.fsf@devron.myhome.or.jp>
In-Reply-To: <87637oi6v8.fsf@devron.myhome.or.jp>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912302144.36718.marvin24@gmx.de>
X-HRZ-JLUG-MailScanner-Information: Passed JLUG virus check
X-HRZ-JLUG-MailScanner: No virus found
X-MailScanner-From: marvin24@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Marvin <marvin24@gmx.de> writes:
> > Hi,
> >
> > I'm getting a lot of these:
> >
> > kernel: general protection fault: 0000 [#1] SMP
> > kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:18.3/modalias
> > kernel: CPU 0
> > kernel: Pid: 12177, comm: packagekitd Not tainted 2.6.33-rc2 #1
> > ...
> >
> > filesystem is ext4 (in case it matters).
> 
> BTW, are you using nfs client on this machine?
>

um - yes, now that I think about it... I killed a nfs umount process (because of an 
offline server) shortly before the oopses started to fire.

Marvin


