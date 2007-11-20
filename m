Return-Path: <linux-kernel-owner+w=401wt.eu-S1763380AbXKTCTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763380AbXKTCTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760163AbXKTCTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 21:19:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48876 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763131AbXKTCTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 21:19:24 -0500
Message-ID: <47424402.6030005@zytor.com>
Date: Mon, 19 Nov 2007 18:18:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 08/45] cpu alloc: x86 support
References: <20071120011132.143632442@sgi.com> <20071120011333.619991903@sgi.com> <474239CA.20403@zytor.com> <Pine.LNX.4.64.0711191759370.19954@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0711191759370.19954@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Mon, 19 Nov 2007, H. Peter Anvin wrote:
> 
>> You're making the assumption here that NUMA = large number of CPUs. This
>> assumption is flat-out wrong.
> 
> Well maybe. Usually one gets to NUMA because the hardware gets too big to 
> be handleed the UMA way.
> 
>> On x86-64, most two-socket systems are still NUMA, and I would expect that
>> most distro kernels probably compile in NUMA.  However,
>> burning megabytes of memory on a two-socket dual-core system when we're
>> talking about tens of kilobytes used would be more than a wee bit insane.
> 
> Yeah yea but the latencies are minimal making the NUMA logic too expensive 
> for most loads ... If you put a NUMA kernel onto those then performance 
> drops (I think someone measures 15-30%?)
> 

How do you handle this memory, in the first place?  Do you allocate the 
whole 2 MB for the particular CPU, or do you reclaim the upper part of 
the large page?  (I haven't dug far enough into the source to tell.)

	-hpa
