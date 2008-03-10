Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbYCJRPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbYCJRPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 13:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755187AbYCJRPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 13:15:19 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39891 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755181AbYCJRPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 13:15:18 -0400
Date: Mon, 10 Mar 2008 10:14:43 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] [0/13] General DMA zone rework
In-Reply-To: <20080308115703.GD27074@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0803101014070.24069@schroedinger.engr.sgi.com>
References: <200803071007.493903088@firstfloor.org>
 <Pine.LNX.4.64.0803071841020.12220@schroedinger.engr.sgi.com>
 <20080308115703.GD27074@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Mar 2008, Andi Kleen wrote:

> I'm afraid it would not help you directly because you would still need 
> to maintain that code for s390 (seems to be a heavy GFP_DMA user)
> and probably some other architectures (unless you can get these
> maintainers to get rid of GFP_DMA too) With my plan it can be just ifdefed
> and the ifdef not enabled on x86.

Undefining ZONE_DMA will remove support for GFP_DMA from the slab 
allocators. Your patch is already doing that.

