Return-Path: <linux-kernel-owner+w=401wt.eu-S1760592AbYFWTV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760592AbYFWTV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 15:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754323AbYFWTVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 15:21:51 -0400
Received: from relay2.sgi.com ([192.48.171.30]:49659 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753992AbYFWTVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 15:21:51 -0400
Date: Mon, 23 Jun 2008 12:21:50 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Steven Rostedt <srostedt@redhat.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 23
In-Reply-To: <Pine.LNX.4.64.0806232155060.4033@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0806231220470.28070@schroedinger.engr.sgi.com>
References: <20080623182549.b0552851.sfr@canb.auug.org.au> 
 <19f34abd0806230323o6373015fj93a85b929545a7a8@mail.gmail.com> 
 <19f34abd0806230326i592ba39eu837d290e21431d14@mail.gmail.com>
 <19f34abd0806230402x502eca3cna927eb8742553570@mail.gmail.com>
 <Pine.LNX.4.64.0806232155060.4033@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008, Pekka J Enberg wrote:

> Christoph, while the warning itself seems harmless, I think we need to do 
> something like the following; otherwise the return value for 
> kmem_cache_defrag() will be incorrect on NUMA machines that have more than 
> one N_NORMAL_MEMORY nodes.

Patch looks to be the right fix. Thanks.

Acked-by: Christoph Lameter <clameter@sgi.com>

