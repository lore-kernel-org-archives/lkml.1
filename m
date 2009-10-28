Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbZJ1SgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbZJ1SgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 14:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbZJ1SgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 14:36:19 -0400
Received: from mail.gmx.net ([213.165.64.20]:43648 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754668AbZJ1SgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 14:36:16 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+m/jULng+myhDGNGo6QaNZV7yLj3DlDltTTgjHln
	10II8Y+GTfSWN6
Subject: Re: [PATCH 3/3] sched: Disable affine wakeups by default
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <1256714741.10387.4.camel@marge.simson.net>
References: <20091024125853.35143117@infradead.org>
	 <20091024130432.0c46ef27@infradead.org>
	 <20091024130728.051c4d7c@infradead.org>
	 <1256453725.12138.40.camel@marge.simson.net>
	 <20091025095109.449bac9e@infradead.org>
	 <1256492289.14241.40.camel@marge.simson.net>
	 <20091025123319.2b76bf69@infradead.org>
	 <1256508287.17306.14.camel@marge.simson.net>
	 <1256522035.7356.19.camel@laptop>
	 <1256654138.17752.7.camel@marge.simson.net>
	 <1256714741.10387.4.camel@marge.simson.net>
Content-Type: text/plain
Date: Wed, 28 Oct 2009 19:36:18 +0100
Message-Id: <1256754978.8808.47.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-28 at 08:25 +0100, Mike Galbraith wrote:

> (i think i'm going to need that domain flag in a few minutes anyway)

Dirty trick didn't work out.

As long as I let wake_affine() decide whether an affine wakeup should
succeed based on the original cpu and then take the switched out cpu
instead, it worked ok.  Try to be cleaner, and it turned to crud.

	-Mike

