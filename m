Return-Path: <linux-kernel-owner+w=401wt.eu-S1759107AbXIVRoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759107AbXIVRoR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 13:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbXIVRoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 13:44:07 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:59642 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbXIVRoG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 13:44:06 -0400
Date: Sat, 22 Sep 2007 10:42:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Satyam Sharma <satyam@infradead.org>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [34/50] i386: Fix argument signedness warnings
Message-Id: <20070922104245.f3d83ea0.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0709221200210.15712@fbirervta.pbzchgretzou.qr>
References: <200709221231.836138000@suse.de>
	<20070921223234.0A71513DCD@wotan.suse.de>
	<alpine.LFD.0.999.0709221029170.19812@enigma.security.iitk.ac.in>
	<Pine.LNX.4.64.0709221200210.15712@fbirervta.pbzchgretzou.qr>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Sep 2007 12:01:16 +0200 (CEST) Jan Engelhardt wrote:

> 
> On Sep 22 2007 10:36, Satyam Sharma wrote:
> >> from arch/i386/boot/compressed/misc.c:14:
> >> include/asm/processor.h: In function ‘cpuid_count’:
> >                                       ^^^^^^^^^^           ^^^^^^^^^^
> >> include/asm/processor.h:615: warning: pointer targets in passing
> >> argument 1 of ‘native_cpuid’ differ in signedness
> >
> >> include/asm/processor.h:615: warning: pointer targets in passing
> >> argument 2 of ‘native_cpuid’ differ in signedness
> >
> >> include/asm/processor.h:615: warning: pointer targets in passing
> >> argument 3 of ‘native_cpuid’ differ in signedness
> >
> >> include/asm/processor.h:615: warning: pointer targets in passing
> >> argument 4 of ‘native_cpuid’ differ in signedness
> >                ^^^^^^^^^^            ^^^^^^^^^^
> >
> >Yikes. My bad, I had faulty (default) alpine settings (and a sad
> >combination of LANG=en_US.UTF-8) when I made and sent out that patch.
> >Please ensure that this finally gets committed in a somewhat saner and
> >more readable state to the tree.
> 
> I am not too thrilled about gcc using non-ascii for interpunctuation
> (for Western languages)..

Ack.  I usually build with "LC_ALL=C" to make those readable.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
