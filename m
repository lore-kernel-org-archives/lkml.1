Return-Path: <linux-kernel-owner+w=401wt.eu-S1765162AbZFQK5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765162AbZFQK5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 06:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbZFQK5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 06:57:35 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:57330
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751372AbZFQK5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 06:57:34 -0400
X-SpamScore: -30
X-BigFish: VPS-30(z34a4jz1432R98dR936eN1805M62a3Lzz1202hzzz32i17ch6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KLDQFC-03-CT1-01
Date: Wed, 17 Jun 2009 12:57:26 +0200
From: Robert Richter <robert.richter@amd.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 01/16] x86/oprofile: add module parameter option to
	force a core 2 cpu
Message-ID: <20090617105725.GS18016@erda.amd.com>
References: <1245183355-25808-1-git-send-email-jeremy@goop.org> <1245183355-25808-2-git-send-email-jeremy@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1245183355-25808-2-git-send-email-jeremy@goop.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 17 Jun 2009 10:57:27.0250 (UTC) FILETIME=[67082B20:01C9EF3A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.06.09 13:15:40, Jeremy Fitzhardinge wrote:
> From: Robert Richter <robert.richter@amd.com>
> 
> The current userland does not yet fully support all cpu types
> implemented in the kernel. With the module parameter:
> 
>  oprofile.cpu_type=core_2
> 
> the kernel reports a core_2 cpu to the userland on an Intel system and
> thus makes oprofile usable with current distros.
> 
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  Documentation/kernel-parameters.txt |    3 ++-
>  arch/x86/oprofile/nmi_int.c         |   17 ++++++++++++++---
>  2 files changed, 16 insertions(+), 4 deletions(-)

Jeremy,

I dropped this patch. See this thread:

 http://lkml.org/lkml/2009/5/6/234

Does your patch series depends on this?

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

