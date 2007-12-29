Return-Path: <linux-kernel-owner+w=401wt.eu-S1756746AbXL2Ith@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbXL2Ith (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 03:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756633AbXL2ItY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 03:49:24 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57274 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620AbXL2ItT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 03:49:19 -0500
Date: Sat, 29 Dec 2007 10:49:17 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <clameter@sgi.com>,
       akpm@linux-foundation.org
Subject: Re: [PATCH] slab: avoid double initialization & do it in 1 function
In-Reply-To: <20071227202849.GA11114@joi>
Message-ID: <Pine.LNX.4.64.0712291048130.25529@sbz-30.cs.Helsinki.FI>
References: <20071227202849.GA11114@joi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcin,

On Thu, 27 Dec 2007, Marcin Slusarz wrote:
> * alloc_slabmgmt: initialize all slab fields in 1 function
> * slab->nodeid was initialized twice: in alloc_slabmgmt
>   and immediately after it in cache_grow

Looks good to me.

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
