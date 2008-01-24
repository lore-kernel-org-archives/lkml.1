Return-Path: <linux-kernel-owner+w=401wt.eu-S1756392AbYAXPTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbYAXPTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 10:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbYAXPSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 10:18:46 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:35392
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085AbYAXPSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 10:18:45 -0500
Message-ID: <4798AC4E.4060307@qumranet.com>
Date: Thu, 24 Jan 2008 17:18:38 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrea Arcangeli <andrea@qumranet.com>
CC: Andrew Morton <akpm@osdl.org>, Nick Piggin <npiggin@suse.de>,
       linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       steiner@sgi.com, linux-kernel@vger.kernel.org,
       kvm-devel@lists.sourceforge.net, daniel.blueman@quadrics.com,
       holt@sgi.com, Hugh Dickins <hugh@veritas.com>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [kvm-devel] [PATCH] export notifier #1
References: <20080117193252.GC24131@v2.random>	<20080121125204.GJ6970@v2.random> <4795F9D2.1050503@qumranet.com>	<20080122144332.GE7331@v2.random>	<20080122200858.GB15848@v2.random>	<Pine.LNX.4.64.0801221232040.28197@schroedinger.engr.sgi.com>	<20080122223139.GD15848@v2.random>	<Pine.LNX.4.64.0801221433080.2271@schroedinger.engr.sgi.com>	<20080123114136.GE15848@v2.random>	<Pine.LNX.4.64.0801231149150.13547@schroedinger.engr.sgi.com>	<20080124143454.GN7141@v2.random> <4798AB96.4000408@qumranet.com>
In-Reply-To: <4798AB96.4000408@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Andrea Arcangeli wrote:
>   
>> The remote page fault
>>   
>>     
>
> As we have two names for this ('shadow' and 'remote/export') I'd like to 
> suggest a neutral nomenclature.  How about 'secondary mmu' (and 
> secondary ptes (sptes), etc.)?  I think this fits xpmem, kvm, rdma, and dri.
>
>   

Er, it was Robin who came up with this first, I see.  Let's just say I 
second the motion.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

