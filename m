Return-Path: <linux-kernel-owner+w=401wt.eu-S1757806AbYCCUSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806AbYCCUSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 15:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbYCCURc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 15:17:32 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56719 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756646AbYCCURV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 15:17:21 -0500
Date: Mon, 3 Mar 2008 12:17:20 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [rfc][patch 2/3] slab: introduce SMP alignment
In-Reply-To: <20080303201211.GE8974@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0803031216430.3110@schroedinger.engr.sgi.com>
References: <20080303093449.GA15091@wotan.suse.de> <20080303093529.GB15091@wotan.suse.de>
 <Pine.LNX.4.64.0803031104570.6917@schroedinger.engr.sgi.com>
 <20080303200355.GB8974@wotan.suse.de> <Pine.LNX.4.64.0803031208400.16049@schroedinger.engr.sgi.com>
 <20080303201211.GE8974@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, Nick Piggin wrote:

> > You want two ways of specifying alignments?
> 
> I want a way to ask for SMP friendly allocation.

Then align the objects at cacheline boundaries by providing a value for 
the align parameter to kmem_cache_create().
 
