Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab0BFOSu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 09:18:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51673 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab0BFOSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 09:18:49 -0500
Subject: Re: [RFC PATCH] perf_core: provide a kernel-internal interface to
 get to performance counters
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
In-Reply-To: <20100206114634.GE5062@nowhere>
References: <20090925122556.2f8bd939@infradead.org>
	 <20100205154748.GA11469@infradead.org>
	 <20100205222430.1d17a72c@infradead.org>  <20100206114634.GE5062@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 06 Feb 2010 15:18:42 +0100
Message-ID: <1265465922.30057.510.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-06 at 12:46 +0100, Frederic Weisbecker wrote:

> We can't. It has a user merged upstream: the hw-breakpoint subsystem.

That's non modular, so removing that EXPORT still makes sense.

