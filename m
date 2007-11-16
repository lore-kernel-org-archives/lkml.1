Return-Path: <linux-kernel-owner+w=401wt.eu-S1758508AbXKPCzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508AbXKPCzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 21:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758940AbXKPCzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 21:55:23 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49362 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758794AbXKPCzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 21:55:22 -0500
Date: Thu, 15 Nov 2007 18:55:21 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: corbet@lwn.net, andi@firstfloor.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
In-Reply-To: <20071115.185051.159765071.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0711151851420.32046@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711151045060.28051@schroedinger.engr.sgi.com>
 <20071115.140305.137877909.davem@davemloft.net>
 <Pine.LNX.4.64.0711151816170.31691@schroedinger.engr.sgi.com>
 <20071115.185051.159765071.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007, David Miller wrote:

> If you're talking about the VMEMMAP thing, that patch didn't remove
> the problem, it simply added optimizations for sparc64 so that you could
> sweep the problem under the rug.

The virtual mapping of the cpu areas is used by the patch I 
posted for i386, ia64 and x86_64. All the ones that I have access to here.

> Sparc32 is still broken, as just one of several possible examples.

I have not looked at sparc32 sorry. If you simply set up a couple of 
configuration values in arch/sparc32/Kconfig then everything will be fine.

> The BSS usage is still there for platforms that don't use VMEMMAP.

All MMU platforms can use the virtual mappings. The main use of the static 
configuration is for embedded systems.
