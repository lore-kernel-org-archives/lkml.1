Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbXHVAeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbXHVAeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 20:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbXHVAeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 20:34:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbXHVAeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 20:34:14 -0400
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
References: <20070820215413.GA28452@Krystal>
	<Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com>
	<20070821173849.GA8360@Krystal>
	<Pine.LNX.4.64.0708211404290.3082@schroedinger.engr.sgi.com>
	<20070821231216.GA29691@Krystal>
	<Pine.LNX.4.64.0708211614370.6062@schroedinger.engr.sgi.com>
	<20070821233938.GD29691@Krystal>
	<Pine.LNX.4.64.0708211640430.6225@schroedinger.engr.sgi.com>
	<20070821234702.GE29691@Krystal>
	<Pine.LNX.4.64.0708211649260.6886@schroedinger.engr.sgi.com>
	<20070822000323.GG29691@Krystal>
From: Andi Kleen <andi@firstfloor.org>
Date: 22 Aug 2007 03:28:07 +0200
In-Reply-To: <20070822000323.GG29691@Krystal>
Message-ID: <p73fy2cz7bs.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
> 
> The measurements I get (in cycles):
>              enable interrupts (STI)   disable interrupts (CLI)   local CMPXCHG
> IA32 (P4)    112                        82                         26
> x86_64 AMD64 125                       102                         19

What exactly did you benchmark here? On K8 CLI/STI are only supposed
to be a few cycles. pushf/popf might me more expensive, but not that much.

-Andi
