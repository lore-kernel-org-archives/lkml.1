Return-Path: <linux-kernel-owner+w=401wt.eu-S1759579AbXJLEmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759579AbXJLEmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 00:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbXJLEm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 00:42:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40772 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbXJLEm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 00:42:27 -0400
Date: Fri, 12 Oct 2007 13:41:52 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [Patch 001/002] extract kmem_cache_shrink
Cc: Andrew Morton <akpm@osdl.org>,
       Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <Pine.LNX.4.64.0710112054220.1882@schroedinger.engr.sgi.com>
References: <20071012112648.B99F.Y-GOTO@jp.fujitsu.com> <Pine.LNX.4.64.0710112054220.1882@schroedinger.engr.sgi.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20071012134021.B9A7.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 12 Oct 2007, Yasunori Goto wrote:
> 
> > Make kmem_cache_shrink_node() for callback routine of memory hotplug
> > notifier. This is just extract a part of kmem_cache_shrink().
> 
> Could we just call kmem_cache_shrink? It will do the shrink on every node 
> but memory hotplug is rare?

Yes it is. Memory hotplug is rare.
Ok. I'll do it.

Thanks.
-- 
Yasunori Goto 


