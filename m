Return-Path: <linux-kernel-owner+w=401wt.eu-S1758253AbXKMP1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253AbXKMP1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 10:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbXKMP1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 10:27:30 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:23279 "EHLO
	outbound4-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754859AbXKMP13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 10:27:29 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
Date: Tue, 13 Nov 2007 16:17:18 +0100
From: "Robert Richter" <robert.richter@amd.com>
To: "Andi Kleen" <andi@firstfloor.org>
cc: gregkh@suse.de, akpm@osdl.org, eranian@hpl.hp.com,
       linux-kernel@vger.kernel.org, perfmon2-devel@lists.sourceforge.net
Subject: perfmon2 merge news
Message-ID: <20071113151718.GA3804@erda.amd.com>
References: <20071107003454.GA13374@kroah.com>
 <20071109120627.60ec9ab4.akpm@linux-foundation.org>
 <20071109213829.GC28276@kroah.com> <p73abpl2654.fsf@bingen.suse.de>
MIME-Version: 1.0
In-Reply-To: <p73abpl2654.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 13 Nov 2007 15:17:18.0849 (UTC)
 FILETIME=[47EEDF10:01C82608]
X-WSS-ID: 6B271F8B24S2339257-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.11.07 21:32:39, Andi Kleen wrote:
> It would be really good to extract a core perfmon and start with
> that and then add stuff as it makes sense.
> 
> e.g. core perfmon could be something simple like just support
> to context switch state and initialize counters in a basic way 
> and perhaps get counter numbers for RDPMC in ring3 on x86[1]

Perhaps a core could provide also as much functionality so that
Perfmon can be used with an *unpatched* kernel using loadable modules?
One drawback with today's Perfmon is that it can not be used with a
vanilla kernel. But maybe such a core is by far too complex for a
first merge.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com


