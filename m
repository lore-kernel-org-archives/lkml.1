Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbYCYRxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbYCYRxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 13:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbYCYRxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 13:53:12 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36328 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753112AbYCYRxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 13:53:10 -0400
Date: Tue, 25 Mar 2008 10:51:18 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [13/14] vcompound: Use vcompound for swap_map
In-Reply-To: <20080325175508.GV2170@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0803251051060.16206@schroedinger.engr.sgi.com>
References: <20080321061703.921169367@sgi.com> <20080321061727.269764652@sgi.com>
 <8763vfixb8.fsf@basil.nowhere.org> <Pine.LNX.4.64.0803241253250.4218@schroedinger.engr.sgi.com>
 <20080325075236.GG2170@one.firstfloor.org> <Pine.LNX.4.64.0803251043140.15870@schroedinger.engr.sgi.com>
 <20080325175508.GV2170@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008, Andi Kleen wrote:

> Not when the trick of getting high order, returning left over pages
> is used. I meant just updating the GFP_COMPOUND code to always
> use number of pages instead of order so that it could deal with a compound
> where the excess pages are already returned. That is not actually that 
> much work (I reimplemented this recently for dma alloc and it's < 20 LOC) 

Would you post the patch here?
