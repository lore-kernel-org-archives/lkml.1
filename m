Return-Path: <linux-kernel-owner+w=401wt.eu-S1752947AbZK3Ibw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbZK3Ibw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 03:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbZK3Ibv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 03:31:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:43655 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbZK3Ibv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 03:31:51 -0500
Subject: Re: [PATCH] sched: Fix isolcpus boot option
From: Peter Zijlstra <peterz@infradead.org>
To: Anton Blanchard <anton@samba.org>
Cc: rusty@rustcorp.com.au, mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20091130000532.GW32182@kryten>
References: <20091130000532.GW32182@kryten>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 09:31:47 +0100
Message-ID: <1259569907.13695.550.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 11:05 +1100, Anton Blanchard wrote:
> Might be worth moving cpu_isolated_map into kernel/cpu.c and treat it
> like the other cpu masks but I figured that change would have trouble
> making 2.6.32. Thoughts? 

I'd love to kill off isolcpus in favour of exclusive cpusets, except
that we need a bit more work on the latter to really make that happen.

