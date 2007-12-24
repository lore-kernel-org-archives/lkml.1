Return-Path: <linux-kernel-owner+w=401wt.eu-S1752582AbXLXTNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbXLXTNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 14:13:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbXLXTM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 14:12:56 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37386 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751274AbXLXTM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 14:12:56 -0500
Date: Mon, 24 Dec 2007 11:12:53 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, andi@firstfloor.org,
       a.p.zijlstra@chello.nl
Subject: Re: [PATCH] slub: /proc/slabinfo ABI compatibility
In-Reply-To: <20071222133727.GA12031@elte.hu>
Message-ID: <Pine.LNX.4.64.0712241110240.8802@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0712221446280.24655@sbz-30.cs.Helsinki.FI>
 <20071222131601.GB32558@elte.hu> <20071222133727.GA12031@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Dec 2007, Ingo Molnar wrote:

> Pekka, i stuck your patch into the x86.git random-test-grid, and it 
> found the following build error after a few iterations:
> 
>   mm/slub.c: In function 's_show':
>   mm/slub.c:4188: error: implicit declaration of function 'count_partial'
> 
> find the (tested) fix below.

Hmmm... What is the combination of config variables that causes this? I 
moved the count_partial function in mm in order to make the merge of slab 
defrag easier.
