Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbYAOKyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbYAOKyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 05:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbYAOKyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 05:54:37 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56430 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751112AbYAOKyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 05:54:35 -0500
Date: Tue, 15 Jan 2008 02:54:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Georgi Chulkov <g.chulkov@jacobs-university.de>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: ATA device reset, shoud I be concerned?
Message-Id: <20080115025435.1e21b703.akpm@linux-foundation.org>
In-Reply-To: <200801140019.20668.g.chulkov@jacobs-university.de>
References: <200801140019.20668.g.chulkov@jacobs-university.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2008 00:19:20 +0200 Georgi Chulkov <g.chulkov@jacobs-university.de> wrote:

> Hello,
> 
> During heavy disk load on my laptop, sometimes the IDE disk will pause for a 
> second and then continue. I get this in my kernel log:
> 
> [ 9031.028000] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 
> frozen
> [ 9031.028000] ata1.00: cmd c8/00:08:90:ca:ce/00:00:00:00:00/e0 tag 0 cdb 0x0 
> data 4096 in
> [ 9031.028000]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
> (timeout)
> [ 9036.068000] ata1: port is slow to respond, please be patient (Status 0xd0)
> [ 9041.052000] ata1: device not ready (errno=-16), forcing hardreset
> [ 9041.052000] ata1: soft resetting port
> [ 9041.232000] ata1.00: configured for UDMA/100
> [ 9041.232000] ata1: EH complete
> [ 9041.248000] sd 0:0:0:0: [sda] 78140160 512-byte hardware sectors (40008 MB)
> [ 9041.248000] sd 0:0:0:0: [sda] Write Protect is off
> [ 9041.248000] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [ 9041.248000] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
> doesn't support DPO or FUA
> 
> My question: What is this telling me, and do I need to be concerned? 
> Everything continues to work normally after the message: no I/O errors, no 
> fsck errors, etc.
> 
> I've seen some similar reports on the mailing list, but they include slightly 
> different messages. I would appreciate any information!
> 
> uname -a (on Kubuntu Gutsy, CPU is a single-core 32-bit Pentium M):
> 
> Linux superfly 2.6.22-14-386 #1 Tue Dec 18 07:34:24 UTC 2007 i686 GNU/Linux
> 

Has it done this in all kernel versions or did some earler version work OK?
