Return-Path: <linux-kernel-owner+w=401wt.eu-S1764793AbYARS4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764793AbYARS4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756944AbYARS4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:56:42 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33604 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755886AbYARS4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:56:41 -0500
Date: Fri, 18 Jan 2008 10:56:41 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: travis@sgi.com, Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] x86: Add debug of invalid per_cpu map accesses
In-Reply-To: <200801181933.05662.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0801181055320.30775@schroedinger.engr.sgi.com>
References: <20080118183011.354965000@sgi.com> <20080118183012.050317000@sgi.com>
 <200801181933.05662.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008, Andi Kleen wrote:

> On Friday 18 January 2008 19:30:16 travis@sgi.com wrote:
> > Provide a means to trap usages of per_cpu map variables before
> > they are setup.  Define CONFIG_DEBUG_PER_CPU_MAPS to activate.
> 
> Are you sure that debug option is generally useful enough
> to merge? It seems very specific to your patchkit, but I'm not
> sure it would be worth carrying forever in the kernel.
> 
> Better would be probably to just unmap those areas anyways.

Its generally useful also for the cpu_alloc changes that may lead 
to the moving around of early initialization code for consolidation of 
code between i386 and x86_64 once Mike's initial patchset is in.

