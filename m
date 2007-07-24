Return-Path: <linux-kernel-owner+w=401wt.eu-S1760766AbXGXRxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766AbXGXRxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 13:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbXGXRxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 13:53:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:46455 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbXGXRxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 13:53:10 -0400
To: Aaron Porter <atporter@primate.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: miserable performance of 2.6.21 under network load
References: <20070724172513.GB24543@primate.net>
From: Andi Kleen <andi@firstfloor.org>
Date: 24 Jul 2007 20:48:00 +0200
In-Reply-To: <20070724172513.GB24543@primate.net>
Message-ID: <p73vec9sknz.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Aaron Porter <atporter@primate.net> writes:

> 	I'm in the process up upgrading a pool of apache servers from
> 2.6.17.8 to 2.6.21.5, and we're seeing a pretty major change in behavior.
> Under identical network load, 2.6.21 has a load average more than 3 times
> higher, cpu 0 spends well over 90% of its time in interrupts (vs ~30%
> under 2.6.17). When we hit 3k apache sessions, ksoftirqd eats 100% of cpu0
> and our network traffic drops off rapidly. The end result is that 2.6.17
> performs twice as well under this load.

Can you oprofile it?

-Andi
