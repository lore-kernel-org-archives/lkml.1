Return-Path: <linux-kernel-owner+w=401wt.eu-S1763200AbXKMWA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763200AbXKMWA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 17:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760247AbXKMWAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 17:00:47 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46241 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759837AbXKMWAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 17:00:46 -0500
Date: Tue, 13 Nov 2007 14:00:45 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
In-Reply-To: <473A1DEA.7000307@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0711131400050.3714@schroedinger.engr.sgi.com>
References: <20071106195144.983665861@sgi.com> <20071106195157.878563669@sgi.com>
 <20071113.031510.151440585.davem@davemloft.net>
 <Pine.LNX.4.64.0711131339240.3714@schroedinger.engr.sgi.com>
 <473A1DEA.7000307@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007, Eric Dumazet wrote:

> Once you add in mm/vmalloc.c all needed helpers, no need to use BSS Megablob
> anymore ?

Well I think all of this can be avoided by simply copying the existing 
vmemmap helper functions and providing a virtual address for sparc64.

