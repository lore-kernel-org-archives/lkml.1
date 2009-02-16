Return-Path: <linux-kernel-owner+w=401wt.eu-S1758080AbZBPN6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080AbZBPN6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 08:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbZBPN6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 08:58:47 -0500
Received: from cmpxchg.org ([85.214.51.133]:51205 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbZBPN6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 08:58:46 -0500
Date: Mon, 16 Feb 2009 15:00:55 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH] net: replace commatas with semicolons
Message-ID: <20090216140055.GB6927@cmpxchg.org>
References: <alpine.LFD.2.00.0902132243480.3616@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902132243480.3616@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 10:46:21PM +0100, Thomas Gleixner wrote:
> Impact: syntax fix
> 
> Interestingly enough this compiles w/o any complaints:
> 
> 	orphans = percpu_counter_sum_positive(&tcp_orphan_count),
> 	sockets = percpu_counter_sum_positive(&tcp_sockets_allocated),

C's equivalent of Common Lisps PROGN.  Try:

	a = (foo(), 2);

it's magic!

	Hannes
