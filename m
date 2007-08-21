Return-Path: <linux-kernel-owner+w=401wt.eu-S1757750AbXHUXld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750AbXHUXld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 19:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbXHUXl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 19:41:26 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33307 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753707AbXHUXlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 19:41:25 -0400
Date: Tue, 21 Aug 2007 16:41:25 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
In-Reply-To: <20070821233938.GD29691@Krystal>
Message-ID: <Pine.LNX.4.64.0708211640430.6225@schroedinger.engr.sgi.com>
References: <20070820204126.GA22507@Krystal>
 <Pine.LNX.4.64.0708201346160.30353@schroedinger.engr.sgi.com>
 <20070820212922.GA27011@Krystal> <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com>
 <20070820215413.GA28452@Krystal> <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com>
 <20070821173849.GA8360@Krystal> <Pine.LNX.4.64.0708211404290.3082@schroedinger.engr.sgi.com>
 <20070821231216.GA29691@Krystal> <Pine.LNX.4.64.0708211614370.6062@schroedinger.engr.sgi.com>
 <20070821233938.GD29691@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007, Mathieu Desnoyers wrote:

> Using cmpxchg_local vs cmpxchg has a clear impact on the fast paths, as
> shown below: it saves about 60 to 70 cycles for kmalloc and 200 cycles
> for the kmalloc/kfree pair (test 2).

Hmmmm.. I wonder if the AMD processors simply do the same in either 
version.
