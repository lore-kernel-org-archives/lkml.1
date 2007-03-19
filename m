Return-Path: <linux-kernel-owner+w=401wt.eu-S1030753AbXCSX56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030753AbXCSX56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 19:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030754AbXCSX55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 19:57:57 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34543 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030753AbXCSX54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 19:57:56 -0400
Date: Mon, 19 Mar 2007 16:57:55 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 1/5] Quicklists for page table pages V3
In-Reply-To: <20070319165329.b5830789.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703191655190.13879@schroedinger.engr.sgi.com>
References: <20070319233716.13775.45569.sendpatchset@schroedinger.engr.sgi.com>
 <20070319165329.b5830789.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007, Andrew Morton wrote:

> Has it been proven that quicklists are superior to simply going direct to the
> page allocator for these pages?

Yes.
 
> Would it provide a superior solution if we were to a) stop zeroing out the
> pte's when doing a fullmm==1 teardown and b) go direct to the page allocator
> for these pages?

I doubt it. The zeroing is a by product of our way of serializing pte 
handling. Its going to be difficult to change that.


