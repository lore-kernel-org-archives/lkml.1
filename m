Return-Path: <linux-kernel-owner+w=401wt.eu-S1760704AbYF0QNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704AbYF0QNJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 12:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbYF0QM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 12:12:56 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:27361 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbYF0QMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 12:12:55 -0400
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH] x86: don't destroy %rbp on kernel-mode faults
From: Andi Kleen <andi@firstfloor.org>
References: <20080627152216.GA8852@damson.getinternet.no>
Date: Fri, 27 Jun 2008 18:12:50 +0200
In-Reply-To: <20080627152216.GA8852@damson.getinternet.no> (Vegard Nossum's message of "Fri, 27 Jun 2008 17:22:17 +0200")
Message-ID: <874p7erh4t.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 Jun 2008 16:05:31.0283 (UTC) FILETIME=[9FBA8630:01C8D86F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum <vegard.nossum@gmail.com> writes:

> Hi,
>
> I sent this patch earlier, but it was never queued. It has been acked by
> Arjan and acked informally by Andi. I hope this can make it for 2.6.27.

Just to clarify the "informal ack" was (paraphrased): 

All the .S code was always designed to support dwarf2 unwinding and
not frame pointers and there are a lot more places that don't care
about frame pointers. So even if you fix it here it'll still break in
other places.

-Andi

