Return-Path: <linux-kernel-owner+w=401wt.eu-S1761948AbYD3I2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761948AbYD3I2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 04:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754935AbYD3I2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 04:28:01 -0400
Received: from mail-ausfall.charite.de ([193.175.70.131]:49566 "EHLO
	mail-ausfall.charite.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206AbYD3I2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 04:28:00 -0400
Date: Wed, 30 Apr 2008 10:27:58 +0200
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: Linux Kernel Maillist <linux-kernel@vger.kernel.org>
Subject: Re: HP server and atto driver from hell
Message-ID: <20080430082758.GD6721@charite.de>
Mail-Followup-To: Linux Kernel Maillist <linux-kernel@vger.kernel.org>
References: <20080429201727.GV8066@charite.de> <Pine.LNX.4.64.0804291425260.23575@filesrv1.baby-dragons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0804291425260.23575@filesrv1.baby-dragons.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mr. James W. Laferriere <babydr@baby-dragons.com>:

> Hello Ralf , Fyi , the fusion/mpt driver supports some of the ATTO 
> devices , if your lspci -v for the ATTO controllers looks simular to
> this one it may just work with the fusion drivers . Hth , JimL

I will try.

> # lspci -v -s 0d:04.0
> 0d:04.0 SCSI storage controller: Atto Technology Ultra320 SCSI Host Adapter (rev 08)
>         Subsystem: Atto Technology Unknown device 8027
>         Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 16
>         I/O ports at 5000 [size=256]
>         Memory at d8640000 (64-bit, non-prefetchable) [size=256K]
>         Memory at d8600000 (64-bit, non-prefetchable) [size=256K]
>         Capabilities: [50] Power Management version 2
>         Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
>         Capabilities: [68] PCI-X non-bridge device

The device is 802F, not 8027, but I'll try.

-- 
Ralf Hildebrandt (i.A. des IT-Zentrums)         Ralf.Hildebrandt@charite.de
Charite - Universitätsmedizin Berlin            Tel.  +49 (0)30-450 570-155
Gemeinsame Einrichtung von FU- und HU-Berlin    Fax.  +49 (0)30-450 570-962
IT-Zentrum Standort CBF                 send no mail to snickebo@charite.de
