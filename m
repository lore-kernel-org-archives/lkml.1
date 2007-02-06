Return-Path: <linux-kernel-owner+w=401wt.eu-S933122AbXBFSi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122AbXBFSi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 13:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933177AbXBFSi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 13:38:57 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:42204 "EHLO
	outbound7-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933122AbXBFSi4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 13:38:56 -0500
X-BigFish: VP
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: Slower CPU frequency reported by the kernel
Date: Tue, 6 Feb 2007 12:38:11 -0600
Message-ID: <1449F58C868D8D4E9C72945771150BDFD965A1@SAUSEXMB1.amd.com>
In-Reply-To: <eq1ukv$p21$1@sea.gmane.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Slower CPU frequency reported by the kernel
Thread-Index: AcdHjmzID9dhgXb2QoehmN2NNmIZ1ACj00hw
References: <38b2ab8a0702020311o54789ef6xff819dc3b492b005@mail.gmail.com>
 <eq1ukv$p21$1@sea.gmane.org>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: lnx.tmp@gmail.com, linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 06 Feb 2007 18:38:11.0643 (UTC)
 FILETIME=[F44B48B0:01C74A1D]
X-WSS-ID: 69D6149E2MC7262044-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'm using a PC with AMD 64 3000+ cpu which is theoricaly running at
> > 2Ghz. But when looking at /proc/cpuinfo, the kernel reports that it
> > runs only at 1Ghz:
> > ...
> > What's going wrong ?
> 
> Do you have feature called "Cool N' Quiet" enabled in BIOS?
> I had the same problem and disabling the feature the problem resolved.

Linux reports the frequency the processor is currently running at.
Cool N' Quiet is a feature that allows the processor to run at a
lower frequency and voltage when it is idle, thereby saving you
power and letting your fans run slower and quieter.  Don't turn it
off.

-Mark Langsdorf
AMD, Inc.


