Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbYABSyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbYABSyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 13:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbYABSx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 13:53:59 -0500
Received: from relay1.sgi.com ([192.48.171.29]:33154 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752542AbYABSx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 13:53:58 -0500
Date: Wed, 2 Jan 2008 10:53:54 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] procfs: provide slub's /proc/slabinfo
In-Reply-To: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0801021053090.19057@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jan 2008, Hugh Dickins wrote:

> SLUB's new slabinfo isn't there: it looks as if a last minute change
> to Pekka's patch left it dependent on CONFIG_SLAB at the procfs end:
> allow for CONFIG_SLUB too.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

I just saw the patch in Linus tree and wondered how this is going to work 
without the piece that you are providing here.

Acked-by: Christoph Lameter <clameter@sgi.com>

