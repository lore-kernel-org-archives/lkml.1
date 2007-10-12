Return-Path: <linux-kernel-owner+w=401wt.eu-S1752145AbXJLEJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbXJLEJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 00:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbXJLEJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 00:09:16 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36819 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753154AbXJLEJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 00:09:15 -0400
Date: Thu, 11 Oct 2007 21:09:14 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Yasunori Goto <y-goto@jp.fujitsu.com>
cc: Andrew Morton <akpm@osdl.org>,
       Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [Patch 001/002] extract kmem_cache_shrink
In-Reply-To: <20071012112648.B99F.Y-GOTO@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0710112054220.1882@schroedinger.engr.sgi.com>
References: <20071012111008.B995.Y-GOTO@jp.fujitsu.com>
 <20071012112236.B99B.Y-GOTO@jp.fujitsu.com> <20071012112648.B99F.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2007, Yasunori Goto wrote:

> Make kmem_cache_shrink_node() for callback routine of memory hotplug
> notifier. This is just extract a part of kmem_cache_shrink().

Could we just call kmem_cache_shrink? It will do the shrink on every node 
but memory hotplug is rare?
