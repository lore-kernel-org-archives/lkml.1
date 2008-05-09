Return-Path: <linux-kernel-owner+w=401wt.eu-S1760635AbYEICZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760635AbYEICZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 22:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbYEICYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 22:24:50 -0400
Received: from pxy2nd.nifty.com ([202.248.175.14]:20968 "HELO pxy2nd.nifty.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752175AbYEICYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 22:24:49 -0400
X-Nifty-SrcIP: [210.131.101.9]
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=pxy2nd-default; d=mbf.nifty.com;
  b=zIateBqkoaIvAULBUmLASSm3WewJENM+10I7bKOcUspHZbaav9bLJrkajmS37npiV3v9Mws5HyaugsxkW4ITzw==  ;
Date: Fri, 09 May 2008 11:22:20 +0900 (JST)
Message-Id: <20080509.112220.74748072.takada@mbf.nifty.com>
To: bzolnier@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: kernel 2.6.25 with ide driver cs5520 does not boot.
From: TAKADA Yoshihito <takada@mbf.nifty.com>
In-Reply-To: <58cb370e0805080607n4f5de192o5a7371fd0fb1e9f8@mail.gmail.com>
References: <20080508.165814.197343623.takada@mbf.nifty.com>
	<58cb370e0805080607n4f5de192o5a7371fd0fb1e9f8@mail.gmail.com>
X-Mailer: Mew version 6.0.50 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for quick reply.

I tried 2.6.26rc1. It hangs same as 2.6.25.
kernel 2.6.26rc1 with cs5520 cannot boot. cs5520 scans ide0 and ide1.
It seems 2nd port DMA base issue was solved.

dmesg is follow:

Uniform Multi-Platform E-EDI driver
ide: Assuming 33MHz system bus speed for PIO modes: override with idebus=xx
Cyrix 5520: IDE controller (0x1078:0x0002 rev 0x00) at  PCI slot 0000:00:12.0
    ide0: BM-DMA at 0x5000-0x5007
    ide1: BM-DMA at 0x5008-0x500f
hda: IC25N030ATCS04-0, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 14
hda: max request size: 128KiB
  (hang)

From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Subject: Re: kernel 2.6.25 with ide driver cs5520 does not boot.
Date: Thu, 8 May 2008 15:07:31 +0200

 (snip)

> 2.6.24 contained a bug in calculating DMA base for the second port (thus
> the error message) but it shouldn't affect anything (ide1 is still probed
> according to dmesg, please let me know if there are some devices on ide1
> that are not getting detected).

I seems that this issue was resolved. Thanks.

