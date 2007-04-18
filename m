Return-Path: <linux-kernel-owner+w=401wt.eu-S2992722AbXDRVLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992722AbXDRVLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 17:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992726AbXDRVLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 17:11:10 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49101 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992721AbXDRVLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 17:11:09 -0400
Date: Wed, 18 Apr 2007 14:11:04 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <clameter@cthulhu.engr.sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix OOM killing processes wrongly thought MPOL_BIND
In-Reply-To: <Pine.LNX.4.64.0704182022440.11100@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0704181409550.7737@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704182022440.11100@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007, Hugh Dickins wrote:

> I only have CONFIG_NUMA=y for build testing: surprised when trying a memhog
> to see lots of other processes killed with "No available memory (MPOL_BIND)".
> memhog is killed correctly once we initialize nodemask in constrained_alloc().
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

Acked-by: Christoph Lameter <clameter@sgi.com>
