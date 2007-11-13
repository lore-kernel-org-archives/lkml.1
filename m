Return-Path: <linux-kernel-owner+w=401wt.eu-S1762955AbXKMVkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762955AbXKMVkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760109AbXKMVkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:40:23 -0500
Received: from relay1.sgi.com ([192.48.171.29]:56927 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756631AbXKMVkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:40:21 -0500
Date: Tue, 13 Nov 2007 13:40:19 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
In-Reply-To: <20071113.031510.151440585.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0711131339240.3714@schroedinger.engr.sgi.com>
References: <20071106195144.983665861@sgi.com> <20071106195157.878563669@sgi.com>
 <20071113.031510.151440585.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007, David Miller wrote:

> One thing you could do is simply use a vmalloc allocation in the
> non-virtualized case.

Yuck. Meaning to add more crappy code. The bss limitations to 8M is a bit 
strange though. Do other platforms have the same issues? 
