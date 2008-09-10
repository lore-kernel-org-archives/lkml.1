Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbYIJWuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbYIJWuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 18:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYIJWuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 18:50:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44958 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbYIJWuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 18:50:03 -0400
Date: Thu, 11 Sep 2008 00:53:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, davej@codemonkey.org.uk,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] CPUMASK: proposal for replacing cpumask_t
Message-ID: <20080910225345.GL7714@one.firstfloor.org>
References: <20080906235036.891970000@polaris-admin.engr.sgi.com> <20080906235037.880702000@polaris-admin.engr.sgi.com> <1220783087.8687.73.camel@twins.programming.kicks-ass.net> <48C53C91.70604@sgi.com> <1220886335.12278.31.camel@twins.programming.kicks-ass.net> <20080908183852.GA3713@elte.hu> <48C84E9E.7080507@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C84E9E.7080507@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here's an initial proposal for abstracting cpumask_t to be either

At least for some cases I don't think you'll get around defining
a "nearby subset of CPUs that can be handled together" type. Handling 1K 
objects all the time in one piece is simply not a good idea.

-Andi
