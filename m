Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbZCUXun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbZCUXun (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 19:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbZCUXud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 19:50:33 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:39357 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbZCUXud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 19:50:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18885.32067.929534.488134@cargo.ozlabs.ibm.com>
Date: Sun, 22 Mar 2009 10:50:27 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter: remove the event config bitfields
In-Reply-To: <1237673068.3922.257.camel@laptop>
References: <18884.29385.854691.357234@cargo.ozlabs.ibm.com>
	<20090321094246.GA5594@elte.hu>
	<18884.47341.106849.379374@cargo.ozlabs.ibm.com>
	<20090321095651.GA7201@elte.hu>
	<1237635675.4667.192.camel@laptop>
	<1237673068.3922.257.camel@laptop>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> Paul, I noticed you assign the raw config without mask, is that ok?

Yep.  That doesn't get assigned directly to a hardware register; it
undergoes further processing first, which just pulls out the bits it
needs.  (It's not used directly because the hardware has a couple of
registers that configure all the counters at once, rather than a
configuration register per counter.)

Paul.
