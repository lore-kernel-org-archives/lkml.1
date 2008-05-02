Return-Path: <linux-kernel-owner+w=401wt.eu-S934537AbYEBTWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934537AbYEBTWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932191AbYEBTWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:22:07 -0400
Received: from cpsmtpo-eml01.kpnxchange.com ([213.75.38.150]:28558 "EHLO
	cpsmtpo-eml01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764028AbYEBTWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:22:06 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: [git head] Should X86_PAT really default to yes?
Date: Fri, 2 May 2008 21:22:03 +0200
User-Agent: KMail/1.9.9
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805022122.03576.elendil@planet.nl>
X-OriginalArrivalTime: 02 May 2008 19:22:04.0421 (UTC) FILETIME=[CDDA9350:01C8AC89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With X86_PAT enabled, when X is started I get about 40 lines (with varying 
addresses) like:
kernel: Xorg:3358 /dev/mem expected mapping type write-back for 
807bf000-81000000, got uncached-minus

And when X exits I get a bunch of lines like:
kernel: Xorg:3349 freeing invalid memtype 80020000-8002a000

I also noticed artifacts (a band of about 2 cm high across the screen) after 
X goes to black but before the switch to VT1.

When I unset X86_PAT all this disappeared.

Apparently this has been seen before:
http://lkml.org/lkml/2008/5/2/139

The author of that mail also points to:
http://marc.info/?l=linux-kernel&m=120612742217604&w=2

Is this a bug in PAT or not. If it is, should PAT really be recommended to 
be enabled by default?

System: Intel desktop with D945GCZ mainboard
        Intel(R) Pentium(R) D CPU 3.20GHz
        x86_64 kernel; Debian unstable
Video:  00:02.0 VGA compatible controller [0300]:
        Intel Corporation 82945G/GZ Integrated Graphics Controller
        [8086:2772] (rev 02)

Cheers,
FJP
