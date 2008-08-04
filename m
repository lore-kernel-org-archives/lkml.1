Return-Path: <linux-kernel-owner+w=401wt.eu-S1764348AbYHDVdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764348AbYHDVdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764668AbYHDVcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:32:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51902
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1764653AbYHDVcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:32:24 -0400
Date: Mon, 04 Aug 2008 14:32:21 -0700 (PDT)
Message-Id: <20080804.143221.31929542.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: andrea@qumranet.com, davej@redhat.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 7/7] lockdep: spin_lock_nest_lock()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1217867935.3589.35.camel@twins>
References: <1217861763.3589.13.camel@twins>
	<20080804162657.GI11476@duo.random>
	<1217867935.3589.35.camel@twins>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 04 Aug 2008 18:38:55 +0200

> On Mon, 2008-08-04 at 18:26 +0200, Andrea Arcangeli wrote:
> > The only real place where lockdep is unusable in my experience is
> > preempt-RT, it grinds it to an halt during boot on 8-way before
> > reaching the shell.
> 
> David Miller just did a patch that might fix that.

Peter, your patches are just as effective at making all of my 64-cpu,
128-cpu, etc. machines usable with lockdep.
