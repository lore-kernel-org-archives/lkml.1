Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbYAVUaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbYAVUaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 15:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbYAVUaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 15:30:10 -0500
Received: from hermes.jacobs-university.de ([212.201.44.23]:40521 "EHLO
	hermes.jacobs-university.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751574AbYAVUaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 15:30:08 -0500
From: Georgi Chulkov <g.chulkov@jacobs-university.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: ATA device reset, shoud I be concerned?
Date: Tue, 22 Jan 2008 21:29:57 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <200801140019.20668.g.chulkov@jacobs-university.de> <20080115025435.1e21b703.akpm@linux-foundation.org>
In-Reply-To: <20080115025435.1e21b703.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801222129.57359.g.chulkov@jacobs-university.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It appears that the problem was caused by a faulty power supply. Thanks 
anyway!

On Tuesday 15 January 2008 11:54:35 Andrew Morton wrote:
> On Mon, 14 Jan 2008 00:19:20 +0200 Georgi Chulkov 
<g.chulkov@jacobs-university.de> wrote:
> > Hello,
> >
> > During heavy disk load on my laptop, sometimes the IDE disk will pause
> > for a second and then continue. I get this in my kernel log:
> >
> > [ 9031.028000] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
> > frozen
> > [ 9031.028000] ata1.00: cmd c8/00:08:90:ca:ce/00:00:00:00:00/e0 tag 0 cdb
> > 0x0 data 4096 in
> > [ 9031.028000]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4
> > (timeout)
> > [ 9036.068000] ata1: port is slow to respond, please be patient (Status
> > 0xd0) [ 9041.052000] ata1: device not ready (errno=-16), forcing
> > hardreset [ 9041.052000] ata1: soft resetting port
> > [ 9041.232000] ata1.00: configured for UDMA/100
> > [ 9041.232000] ata1: EH complete
> > [ 9041.248000] sd 0:0:0:0: [sda] 78140160 512-byte hardware sectors
> > (40008 MB) [ 9041.248000] sd 0:0:0:0: [sda] Write Protect is off
> > [ 9041.248000] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> > [ 9041.248000] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
> > enabled, doesn't support DPO or FUA
> >
> > My question: What is this telling me, and do I need to be concerned?
> > Everything continues to work normally after the message: no I/O errors,
> > no fsck errors, etc.
> >
> > I've seen some similar reports on the mailing list, but they include
> > slightly different messages. I would appreciate any information!
> >
> > uname -a (on Kubuntu Gutsy, CPU is a single-core 32-bit Pentium M):
> >
> > Linux superfly 2.6.22-14-386 #1 Tue Dec 18 07:34:24 UTC 2007 i686
> > GNU/Linux
>
> Has it done this in all kernel versions or did some earler version work OK?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


