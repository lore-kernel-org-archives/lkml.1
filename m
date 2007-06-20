Return-Path: <linux-kernel-owner+w=401wt.eu-S1760511AbXFTMcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760511AbXFTMcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 08:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754381AbXFTMcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 08:32:05 -0400
Received: from mail.suse.de ([195.135.220.2]:38834 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934AbXFTMcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 08:32:02 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: =?utf-8?q?Bj=C3=B6rn_Steinbrink?= <B.Steinbrink@gmx.de>
Subject: Re: [PATCH 1/2] Separate the performance counter allocation from the LAPIC NMI watchdog
Date: Wed, 20 Jun 2007 14:31:43 +0200
User-Agent: KMail/1.9.6
Cc: eranian@hpl.hp.com, oprofile-list@lists.sourceforge.net, wcohen@redhat.com,
       perfmon@napali.hpl.hp.com, linux-kernel@vger.kernel.org,
       levon@movementarian.org, akpm@linux-foundation.org, mingo@elte.hu
References: <20070618103214.GA12045@atjola.homenet> <11823357571842-git-send-email-> <11823357591180-git-send-email->
In-Reply-To: <11823357591180-git-send-email->
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200706201431.44014.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 June 2007 12:35:56 Björn Steinbrink wrote:
> The performance counter allocator is tied to the LAPIC NMI watchdog,

That's not true. It's completely independent. It just happens to be in
the same file, but it has no direct functional ties to the watchdog.


> Fix the performance counter allocator by making it independent of the
> LAPIC NMI watchdog. This also fixes a bug in the LAPIC NMI watchdog
> which allocated the wrong performance counter on CPUs with PerfMon
> support.

Combining code movement with functional fixes makes it impossible
to review properly. Don't do that please.

-An
