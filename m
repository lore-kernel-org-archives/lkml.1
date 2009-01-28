Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbZA1Pbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbZA1Pbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 10:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbZA1Pbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 10:31:43 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:50583 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751453AbZA1Pbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 10:31:42 -0500
Date: Wed, 28 Jan 2009 10:31:41 -0500
To: "Catalin(ux) M. BOIE" <catab@embedromix.ro>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Seagate disk freeze for 30 seconds then comes back (RecovComm 10B8B)
Message-ID: <20090128153141.GC26064@csclub.uwaterloo.ca>
References: <alpine.LFD.2.00.0901271739400.2013@mail.embedromix.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901271739400.2013@mail.embedromix.ro>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 11:30:42AM +0200, Catalin(ux) M. BOIE wrote:
> I have a ST9160821AS drive, firmware 3.BHE, and I experience some seldom 
> problems with it. It is in a HP 6715s HP laptop, kernel 2.6.27.5.
> 
> The error message is:
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x80002 action 0x6 frozen
> ata1: SError: { RecovComm 10B8B }
> ata1.00: cmd ca/00:f8:11:b8:38/00:00:00:00:00/ec tag 0 dma 126976 out
> res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1.00: status: { DRDY }
> ata1: hard resetting link
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
> ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
> ata1.00: configured for UDMA/100
> ata1: EH complete
> sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
> 
> When it happens, the system freezes for around 30 seconds.
> 
> Seagate told me that there is no firmware update for this drive.
> 
> Please, let me know if it is a software issue.

This sounds like a very widely known and discussed firmware problem.  It
happens with Linux, Windows, and Mac OS X, as well as various NAS boxes.
It is seagate's fault.  Of course I had only seen it mentioned for the
500GB, 750GB, 1TB and 1.5TB drives.  Somehow yours seems like it should
be a different series, but then again why should a firmware bug not be
duplicated on all their drives.

One discussion is here: http://techreport.com/discussions.x/15863

Seriously annoying for raid users of course when a drive falls out of
the raid for no good reason.


I seem to recall some people had found that if you disabled some part of
the drive caching the problem seemed to go away (as did a lot of the
drive's performance of course).

-- 
Len Sorensen
