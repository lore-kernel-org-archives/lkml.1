Return-Path: <linux-kernel-owner+w=401wt.eu-S1759026AbXJOFpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026AbXJOFpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 01:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbXJOFpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 01:45:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38455 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbXJOFpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 01:45:04 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4712FE33.3000400@s5r6.in-berlin.de>
Date: Mon, 15 Oct 2007 07:44:19 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: David Newall <david@davidnewall.com>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Nick Piggin <piggin@cyberone.com.au>
Subject: Re: What still uses the block layer?
References: <200710112011.22000.rob@landley.net> <4711AF18.3030201@davidnewall.com> <471255E4.3070009@s5r6.in-berlin.de> <200710141836.55211.rob@landley.net>
In-Reply-To: <200710141836.55211.rob@landley.net>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> I was at least attempting to ask a serious question.
...
> Actually, I was going through Documentation/block thinking about making a 
> 00-INDEX for it, but my earlier questions of the scsi guys left me with the 
> impression that the block layer is _not_ used by the SCSI layer.

Ah, so it was about your documentation work.  I already forgot the
context of your previous inquiries.  Alas the tone of them already did
some damage, leading to responses like these.

...
> since 
> every non-embedded modern storage device I'm aware of has been consumed by 
> the SCSI layer (despite none of them actually having a discernably closer 
> relationship to SCSI than ATA did)
...

The Linux SCSI subsystems don't consume, they provide services; nowadays
not only for SCSI hardware and SCSI protocols but also for a number of
subsystems whose tasks are similar enough to SCSI subsystems to make the
SCSI core and upper SCSI layer useful to them too.

BTW:
| Now that IDE disks have been rerouted through the scsi layer, SATA goes
| through the scsi layer, USB goes through the scsi layer, firewire goes
| through the scsi layer...

As a side note, SBP-2 is a SCSI transport protocol, hence ieee1394/sbp2
and firewire/fw-sbp2 are Linux SCSI low-level drivers.  Anything else
would be just wrong and infeasible in this particular case.
-- 
Stefan Richter
-=====-=-=== =-=- -====
http://arcgraph.de/sr/
