Return-Path: <linux-kernel-owner+w=401wt.eu-S1765898AbXGOA6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765898AbXGOA6f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 20:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758430AbXGOA6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 20:58:25 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54327 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755557AbXGOA6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 20:58:25 -0400
Date: Sun, 15 Jul 2007 02:04:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>,
       Linux Kernel Maillist <linux-kernel@vger.kernel.org>
Subject: Re: raid5:md3: read error corrected ,  followed by ,  Machine Check
 Exception: .
Message-ID: <20070715020454.19de921f@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0707141658210.16611@filesrv1.baby-dragons.com>
References: <Pine.LNX.4.64.0707141658210.16611@filesrv1.baby-dragons.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jul 2007 17:08:27 -0700 (PDT)
"Mr. James W. Laferriere" <babydr@baby-dragons.com> wrote:

>  	Hello All ,  I was under the impression that a 'machine check' would be 
> caused by some near to the CPU hardware failure ,  Not a bad disk ?

It indicates a hardware failure

> Jul 14 23:00:26 filesrv2 kernel: sd 2:0:1:0: SCSI error: return code = 0x08000002
> Jul 14 23:00:26 filesrv2 kernel: sdd: Current: sense key: Medium Error
> Jul 14 23:00:26 filesrv2 kernel:     Additional sense: Read retries exhausted

So your disk throws a fit

> Jul 14 23:17:06 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 72269184 on sdd)
> Jul 14 23:17:06 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 72269192 on sdd)

Raid happily recovers the mess

> Jul 14 23:20:28 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 76388336 on sdd)
> Jul 14 23:20:28 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 76388344 on sdd)
> Jul 14 23:38:48 filesrv2 -- MARK --
> CPU 5: Machine Check Exception: 0000000000000004
> CPU 4: Machine Check Exception: 0000000000000004

And at some point at least 18 minutes after the raid incident you log
CPU problems.

Are you sure the box or the room it is in didn't get excessively hot ?
