Return-Path: <linux-kernel-owner+w=401wt.eu-S1759702AbZDQScW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759702AbZDQScW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 14:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756861AbZDQScL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 14:32:11 -0400
Received: from smtp-out.google.com ([216.239.45.13]:51543 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818AbZDQScK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 14:32:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=b+voERzT+h/hRChsw+s2Erj6/9gLY9a7x4xzKDQfK24gd5tMRGvxDaawFLKcE59cj
	pU+xtjkTlLRLP+pxNpISA==
Date: Fri, 17 Apr 2009 11:31:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/uv: fix init of memory-less nodes
In-Reply-To: <tip-28468050e2f5410c04fd737c922f2bea73ddd690@git.kernel.org>
Message-ID: <alpine.DEB.2.00.0904171129310.16240@chino.kir.corp.google.com>
References: <20090417142242.GA23743@sgi.com> <tip-28468050e2f5410c04fd737c922f2bea73ddd690@git.kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009, tip-bot for Jack Steiner wrote:

> Commit-ID:  28468050e2f5410c04fd737c922f2bea73ddd690
> Gitweb:     http://git.kernel.org/tip/28468050e2f5410c04fd737c922f2bea73ddd690
> Author:     Jack Steiner <steiner@sgi.com>
> AuthorDate: Fri, 17 Apr 2009 09:22:42 -0500
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 17 Apr 2009 16:45:29 +0200
> 
> x86/uv: fix init of memory-less nodes
> 
> Add support for nodes that have cpus but no memory.
> The current code was failing to add these nodes
> to the nodes_present_map.
> 
> [ Impact: fix potential boot crash on memory-less UV nodes. ]
> 

This is incomplete, x2apic maps cpus to pxms with a type 2 srat entry and 
that pxm may not have affinity to any type 1 memory structure.
