Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbXFPHz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbXFPHz6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 03:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbXFPHzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 03:55:51 -0400
Received: from relay4.usu.ru ([194.226.235.39]:60328 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbXFPHzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 03:55:51 -0400
Message-ID: <4673978F.4030001@ums.usu.ru>
Date: Sat, 16 Jun 2007 13:55:59 +0600
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Christian Schmidt <lkml@digadd.de>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Help needed: Partitioned software raid > 2TB
References: <46727E7C.8060102@digadd.de> <p73d4zxs2q4.fsf@bingen.suse.de> <46729C14.5000809@digadd.de> <Pine.LNX.4.64.0706151824240.32724@fbirervta.pbzchgretzou.qr> <46737747.1050608@ums.usu.ru> <Pine.LNX.4.64.0706160844230.32724@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0706160844230.32724@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:

> I am not sure (would have to check again), but I believe both opensuse and
> fedora (the latter of which uses LVM for all partitions by default) have
> that working, while still using GRUB.

Keyword: partitions. I.e., they partition the hard drive (so that the first 
31 sectors are available for GRUB) and use LVM on devices such as /dev/hda2. 
But this is not what was needed. I need to use LVM on /dev/hda, without a 
partition table.

> But, what's much more amazing, is
> that GRUB seems to work with raid0 (both BIOS-based and MD)... perhaps
> it's just luck that the needed files are contiguous?

[wild guess] Maybe they set up a raid1 /boot partition?

-- 
Alexander E. Patrakov
