Return-Path: <linux-kernel-owner+w=401wt.eu-S1757931AbXHUVKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbXHUVKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 17:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbXHUVKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 17:10:31 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52308 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753739AbXHUVKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 17:10:31 -0400
Date: Tue, 21 Aug 2007 14:10:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
In-Reply-To: <20070821174424.GB8360@Krystal>
Message-ID: <Pine.LNX.4.64.0708211409370.3082@schroedinger.engr.sgi.com>
References: <20070820201519.512791382@polymtl.ca> <20070820201822.597720007@polymtl.ca>
 <Pine.LNX.4.64.0708201330130.30053@schroedinger.engr.sgi.com>
 <20070820204126.GA22507@Krystal> <Pine.LNX.4.64.0708201346160.30353@schroedinger.engr.sgi.com>
 <20070820212922.GA27011@Krystal> <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com>
 <20070820215413.GA28452@Krystal> <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com>
 <20070821173849.GA8360@Krystal> <20070821174424.GB8360@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007, Mathieu Desnoyers wrote:

> If you are interested in the raw numbers:
> 
> The (very basic) test module follows. Make sure you change get_cycles()
> for get_cycles_sync() if you plan to run this on x86_64.

Which test is which? Would you be able to format this in a way that we can 
easily read it?
