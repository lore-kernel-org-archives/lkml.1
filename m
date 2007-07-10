Return-Path: <linux-kernel-owner+w=401wt.eu-S1763830AbXGJUqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763830AbXGJUqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 16:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760736AbXGJUqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 16:46:39 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41541 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762599AbXGJUqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 16:46:38 -0400
Date: Tue, 10 Jul 2007 13:46:36 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, Martin Bligh <mbligh@mbligh.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] x86_64 - Use non locked version for local_cmpxchg()
In-Reply-To: <20070710051616.GB16148@Krystal>
Message-ID: <Pine.LNX.4.64.0707101345550.3055@schroedinger.engr.sgi.com>
References: <20070708034952.022985379@sgi.com> <p73y7hrywel.fsf@bingen.suse.de>
 <Pine.LNX.4.64.0707090845520.13792@schroedinger.engr.sgi.com>
 <46925B5D.8000507@google.com> <Pine.LNX.4.64.0707091055090.16207@schroedinger.engr.sgi.com>
 <4692A1D0.50308@mbligh.org> <20070709214426.GC1026@Krystal>
 <Pine.LNX.4.64.0707091451200.18780@schroedinger.engr.sgi.com>
 <20070709225817.GA5111@Krystal> <Pine.LNX.4.64.0707091605380.20282@schroedinger.engr.sgi.com>
 <20070710051616.GB16148@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007, Mathieu Desnoyers wrote:

> You are completely right: on x86_64, a bit got lost in the move to
> cmpxchg.h, here is the fix. It applies on 2.6.22-rc6-mm1.

A trival fix. Make sure that it gets merged soon.

Acked-by: Christoph Lameter <clameter@sgi.com>
