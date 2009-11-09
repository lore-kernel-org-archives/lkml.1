Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbZKIM1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbZKIM1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 07:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbZKIM1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 07:27:50 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:2102 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755224AbZKIM1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 07:27:49 -0500
X-SpamScore: 4
X-BigFish: VPS4(z3edbo63cmz4015Laf6Ozz1202hzzz32i176h6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KSUDA4-04-13L-02
X-M-MSG: 
Message-ID: <4AF80AA3.9020400@amd.com>
Date: Mon, 9 Nov 2009 13:27:15 +0100
From: Andre Przywara <andre.przywara@amd.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090329)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: x86/NUMA: Reason for ignoring too small NUMA nodes?
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Nov 2009 12:27:42.0643 (UTC) FILETIME=[08C15030:01CA6138]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

while experimenting with a system with a memory-less NUMA node I 
stumbled upon code in the Linux kernel which ignores nodes containing 
less than a certain amount of RAM, obviously to fix systems with a buggy 
BIOS.
Can you elaborate on this? What kind of incorrect entry have you seen?
To correctly map the memory less node I did a patch to accept at least 
nodes with exactly zero bytes of memory (read: no SRAT memory entry), 
was this special condition also present in the buggy machines?
Another comments reads:
      /*
      * Don't confuse VM with a node that doesn't have the
      * minimum amount of memory:
      */
Is that still a valid statement? How can the VM get confused by a node 
with already exhausted memory resources?
(found in arch/x86/mm/{srat,numa}_64.c)

I'd be grateful for some hints!

Thanks,
Andre.

-- 
Andre Przywara
AMD-Operating System Research Center (OSRC), Dresden, Germany
Tel: +49 351 448 3567 12
----to satisfy European Law for business letters:
Advanced Micro Devices GmbH
Karl-Hammerschmidt-Str. 34, 85609 Dornach b. Muenchen
Geschaeftsfuehrer: Andrew Bowd; Thomas M. McCoy; Giuliano Meroni
Sitz: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

