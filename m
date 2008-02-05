Return-Path: <linux-kernel-owner+w=401wt.eu-S1760721AbYBEUVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760721AbYBEUVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756440AbYBEUV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:21:26 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51443 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743AbYBEUVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:21:25 -0500
Message-ID: <47A8C508.6010305@cs.helsinki.fi>
Date: Tue, 05 Feb 2008 22:20:24 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: SLUB: Support for statistics to help analyze allocator behavior
References: <Pine.LNX.4.64.0802042217460.6801@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0802050923220.14675@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0802051005010.11705@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0802051005010.11705@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 5 Feb 2008, Pekka J Enberg wrote:
> 
>> Hi Christoph,
>>
>> On Mon, 4 Feb 2008, Christoph Lameter wrote:
>>> The statistics provided here allow the monitoring of allocator behavior
>>> at the cost of some (minimal) loss of performance. Counters are placed in
>>> SLUB's per cpu data structure that is already written to by other code.
>> Looks good but I am wondering if we want to make the statistics per-CPU so 
>> that we can see the kmalloc/kfree ping-pong of, for example, hackbench 
> 
> We could do that.... Any idea how to display that kind of information 
> in a meaningful way. Parameter conventions for slabinfo?

We could just print out one total summary and one summary for each CPU 
(and maybe show % of total allocations/fees. That way you can 
immediately spot if some CPUs are doing more allocations/freeing than 
others.

			Pekka
