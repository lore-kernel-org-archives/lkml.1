Return-Path: <linux-kernel-owner+w=401wt.eu-S935294AbXGZRve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935294AbXGZRve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 13:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbXGZRvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 13:51:25 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47715 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763369AbXGZRvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 13:51:24 -0400
Date: Thu, 26 Jul 2007 10:51:23 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [bug] SLUB & freeing locks [was: Re: 2.6.23-rc1: known regressions
 with patches]
In-Reply-To: <1185448275.8197.79.camel@twins>
Message-ID: <Pine.LNX.4.64.0707261048220.2374@schroedinger.engr.sgi.com>
References: <46A47940.7030801@googlemail.com>  <20070726091048.GA7366@elte.hu>
 <1185441963.8197.67.camel@twins>  <1185442353.8197.71.camel@twins> 
 <84144f020707260408t1426a1bcs698afd74b344bbb8@mail.gmail.com>
 <1185448275.8197.79.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Note that debug_check... adds more code to the slab_free hotpath which 
will have a significant performance impact if lockdep is enabled.

Acked-by: Christoph Lameter <clameter@sgi.com>

