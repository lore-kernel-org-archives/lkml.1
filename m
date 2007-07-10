Return-Path: <linux-kernel-owner+w=401wt.eu-S1762912AbXGJSdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762912AbXGJSdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbXGJSdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:33:17 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59868 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751010AbXGJSdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:33:16 -0400
Date: Tue, 10 Jul 2007 11:33:15 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Adrian Bunk <bunk@stusta.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] slub.c:early_kmem_cache_node_alloc() shouldn't be
 __init
In-Reply-To: <20070710124445.GX3492@stusta.de>
Message-ID: <Pine.LNX.4.64.0707101132110.11882@schroedinger.engr.sgi.com>
References: <20070710124445.GX3492@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007, Adrian Bunk wrote:

> This patch fixes the following section mismatch:

Nack.

Can you remove the warning? early_kmem_cache_node_alloc is only used 
during bootstrap. But it is called from a function that is also used 
later.
