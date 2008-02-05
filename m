Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbYBEGRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbYBEGRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 01:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbYBEGRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 01:17:43 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:61526 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbYBEGRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 01:17:43 -0500
To: Gregor Radtke <mail@g-radtke.name>
Cc: linux-kernel@vger.kernel.org, Tim Kunschke <beatmeistah@web.de>
Subject: Re: pata_cs5536 hangs on boot with hdd attached
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1202158828.6229.22.camel@desktop.ein-elch.local>
Date: Tue, 05 Feb 2008 01:16:13 -0500
In-Reply-To: <1202158828.6229.22.camel@desktop.ein-elch.local> (Gregor Radtke's message of "Mon\, 04 Feb 2008 22\:00\:28 +0100")
Message-ID: <yq163x47wsy.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Gregor" == Gregor Radtke <mail@g-radtke.name> writes:

Gregor,

Gregor> I tested with various kernel releases before 2.6.24 (and
Gregor> -rcX), up to 2.6.23.12. Both libata and the old ATA subsystem
Gregor> do work, libata with cs5535.

pata_cs5535 won't drive a 5536 -- they're completely different beasts.
So you haven't been testing what you think you're testing...

Try booting your pata_cs5536 kernel with libata.dma=0

I also suggest you try a kernel with pata_amd compiled in instead of
pata_cs5536.  Slight timings aside there shouldn't be any functional
difference between the way the two drivers configure things.  But let
us know how that goes.  And include the diff of the relevant portion
of the boot logs.

Finally - which drive is it?

-- 
Martin K. Petersen	Oracle Linux Engineering
