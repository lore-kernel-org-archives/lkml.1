Return-Path: <linux-kernel-owner+w=401wt.eu-S1760984AbXHQUkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760984AbXHQUkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 16:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbXHQUj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 16:39:57 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46445 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754545AbXHQUj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 16:39:56 -0400
Date: Fri, 17 Aug 2007 13:39:56 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] Simple Performance Counters: SLUB instrumentation
In-Reply-To: <20070817162154.GB30922@Krystal>
Message-ID: <Pine.LNX.4.64.0708171338440.9404@schroedinger.engr.sgi.com>
References: <1185924312685-git-send-email-clameter@sgi.com>
 <20070817162154.GB30922@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2007, Mathieu Desnoyers wrote:

> Why do you printk inside the timing period ? Filling the printk buffers
> or outputting on things such as serial console could really hurt your
> results.

It was easier to code?

> I hope you run your system with idle=poll and without frequency scaling
> at all, because otherwise your cycle count would be completely off on
> many AMD and Intel CPUs. You can have a look at this (very rough)
> document on the topic: 

The cpu will definitely not be idle during these measurements and no 
frequency scaling is active.
