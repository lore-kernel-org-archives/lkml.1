Return-Path: <linux-kernel-owner+w=401wt.eu-S1759148AbYARFyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759148AbYARFyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 00:54:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbYARFxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 00:53:55 -0500
Received: from mx1.suse.de ([195.135.220.2]:34148 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbYARFxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 00:53:54 -0500
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: make clflush a required feature on x86_64
From: Andi Kleen <andi@firstfloor.org>
References: <20080118045921.GB974@phobos.i.cabal.ca>
Date: Fri, 18 Jan 2008 06:53:53 +0100
In-Reply-To: <20080118045921.GB974@phobos.i.cabal.ca> (Kyle McMartin's message of "Thu\, 17 Jan 2008 23\:59\:21 -0500")
Message-ID: <p734pdbbrwu.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin <kyle@mcmartin.ca> writes:

> Hopefully nobody will be stupid enough to implement a cpu without
> it. Frankly, it seems safe enough given we already require SSE2.
>
> This means the compiler can optimise away "if (!cpu_has_clflush)"
> blocks.

The original required CPUID bit set for x86-64 came out of very
detailed discussions and thinking from AMD. I think they had good
reasons to chose the current set. I would only recommend to depart
from it for very good reasons and frankly you haven't given any.
You're talking about removing two instructions.

One problem that we had in the past is that some simulators
only implement the absolutely minimum feature set and you
might have well broken one of these with this.

-Andi
