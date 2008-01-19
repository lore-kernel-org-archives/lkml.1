Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbYASGfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbYASGfX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 01:35:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbYASGfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 01:35:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbYASGfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 01:35:08 -0500
To: Mel Gorman <mel@csn.ul.ie>
Cc: mingo@elte.hu, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       apw@shadowen.org
Subject: Re: [PATCH 0/2] Relax restrictions on setting CONFIG_NUMA on x86
From: Andi Kleen <andi@firstfloor.org>
References: <20080118153529.12646.5260.sendpatchset@skynet.skynet.ie>
Date: Sat, 19 Jan 2008 07:35:06 +0100
In-Reply-To: <20080118153529.12646.5260.sendpatchset@skynet.skynet.ie> (Mel Gorman's message of "Fri\, 18 Jan 2008 15\:35\:29 +0000 \(GMT\)")
Message-ID: <p73hcha9vc5.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mel@csn.ul.ie> writes:

> A fix[1] was merged to the x86.git tree that allowed NUMA kernels to boot
> on normal x86 machines (and not just NUMA-Q, Summit etc.). I took a look
> at the restrictions on setting NUMA on x86 to see if they could be lifted.

The problem with i386 CONFIG_NUMA previously was not that it didn't
boot on normal non NUMA systems, but that it didn't boot on very
common NUMA systems: Opterons.  Have you tested if that is fixed now?

-Andi
