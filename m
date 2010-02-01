Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab0BAJP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 04:15:56 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39126 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab0BAJPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 04:15:55 -0500
Subject: Re: [PATCH 00/12] perf lock: New subcommand "perf lock", for
 analyzing  lock statistics
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <20100131210707.GF5224@nowhere>
References: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <20100129143403.GJ13771@kernel.dk> <4B641F4D.6090704@dcl.info.waseda.ac.jp>
	 <20100131204408.GC13771@kernel.dk>  <20100131210707.GF5224@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 10:15:20 +0100
Message-ID: <1265015720.24455.101.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-31 at 22:07 +0100, Frederic Weisbecker wrote:
> 
> - We are using the -M option from perf tools which multiplexes every
>   event buffers, which means every cpu commit their lock events in
>   the same buffer. Couple that with the two above reasons, it's supposed
>   to scale at worst.

Why are you doing that? That seems like asking for trouble.. 

