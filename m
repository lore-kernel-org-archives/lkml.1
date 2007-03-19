Return-Path: <linux-kernel-owner+w=401wt.eu-S965731AbXCSG7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965731AbXCSG7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 02:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965751AbXCSG7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 02:59:53 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34814 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965731AbXCSG7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 02:59:52 -0400
Date: Mon, 19 Mar 2007 08:59:50 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] revoke: misc fixes
In-Reply-To: <45FE2189.80709@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0703190859320.6597@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0703160916430.14651@sbz-30.cs.Helsinki.FI> 
 <45FA458C.8050605@yahoo.com.au>  <Pine.LNX.4.64.0703160927240.14902@sbz-30.cs.Helsinki.FI>
  <45FA4984.9000506@yahoo.com.au>  <Pine.LNX.4.64.0703160943460.15253@sbz-30.cs.Helsinki.FI>
  <45FA4C59.1000908@yahoo.com.au> <84144f020703160152h61439b28i9e438238567a4ba0@mail.gmail.com>
 <45FE2189.80709@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007, Nick Piggin wrote:
> So you could just attempt a trylock, and if it works, then you
> could revoke the vma right then and there. OTOH, the patch you
> subsequently posted looks fine, so unless this is performance
> critical then I wouldn't bother ;)

The patch in -mm uses trylock.

			Pekka
