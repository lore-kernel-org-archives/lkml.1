Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbYE2NqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbYE2NqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbYE2NqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:46:03 -0400
Received: from gw.goop.org ([64.81.55.164]:41512 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636AbYE2NqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:46:03 -0400
Message-ID: <483EB375.6080601@goop.org>
Date: Thu, 29 May 2008 14:45:25 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>, x86@kernel.org
Subject: [PATCH 0/2] Preferred fix for Xen page-aligned bug
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

My preferred fix for the Xen page-aligned bss bug you found is this:

   1. Put the __page_aligned_data/bss fix into the x86 tree
   2. Adjust all the x86 uses of page-aligned data/bss to use it
      (thereby fixing the Xen bug)
   3. When all that hits linux-2.6.git, update sh and powerpc.

Patches follow for core+x86.

    J
