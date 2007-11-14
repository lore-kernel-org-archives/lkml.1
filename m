Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbXKNBud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbXKNBud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbXKNBuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:50:25 -0500
Received: from relay1.sgi.com ([192.48.171.29]:33695 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754856AbXKNBuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:50:24 -0500
Date: Tue, 13 Nov 2007 17:50:24 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
In-Reply-To: <20071113.173718.112153027.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0711131748570.6539@schroedinger.engr.sgi.com>
References: <20071106195157.878563669@sgi.com> <20071113.031510.151440585.davem@davemloft.net>
 <Pine.LNX.4.64.0711131418560.4363@schroedinger.engr.sgi.com>
 <20071113.173718.112153027.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007, David Miller wrote:

> BTW, I'm going to stop testing your patches on sparc64 for
> a while until you start to make me feel like you understand
> that ignoring the BSS bloat issue is bad.

Well this is just the fallback. How can I avoid this and still keep a 
constant? Add a new segment to vmlinux.lds.S?
 
