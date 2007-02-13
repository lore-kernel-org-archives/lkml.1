Return-Path: <linux-kernel-owner+w=401wt.eu-S1750926AbXBMRKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750926AbXBMRKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 12:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbXBMRKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 12:10:46 -0500
Received: from dvhart.com ([64.146.134.43]:55540 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbXBMRKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 12:10:45 -0500
Message-ID: <45D1F0B1.3020508@mbligh.org>
Date: Tue, 13 Feb 2007 09:09:05 -0800
From: "Martin J. Bligh" <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       bob.picco@hp.com
Subject: Re: [RFC] [PATCH] more support for memory-less-node.
References: <20070213155736.1131d46a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070213155736.1131d46a.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> In my last posintg, mempolicy-fix-for-memory-less-node patch, there was a 
> discussion 'what do you consider definition of "node" as...?
> I found there is no consensus. But I want to go ahead.
> Before posing patch again, I'd like to discuss more.
> 
> -Kame
> 
> In my understanding, a "node" is a block of cpu, memory, devices.
> and there could be cpu-only-node, memory-only-node, device-only-node...
> 
> There will be discussion. IMHO, to represent hardware configuration
> as it is, this definition is very natural and flexible.
> (And because my work is memory-hotplug, this definition fits me.)
> 
> "Don't support such crazy configuraton" is one of opinions.
> I hear x86_64 doesn't support it and defines node as a block of memory,
> It remaps cpus on memory-less-nodes to other nodes.
> I know ia64 allows memory-less-node. (I don't know about ppc.)
> It works well on my box (and HP's box).

It doesn't make much sense for an architecture independent structure to
be "defined" in different ways by specific architectures. "not
supported" or "currently broken" might be a better description.

Your description of the node is correct, it's an arbitrary container of
one or more resources. Not only is this definition flexible, it's also
very useful, for memory hotplug, odd types of NUMA boxes, etc.

M.
