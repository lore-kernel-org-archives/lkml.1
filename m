Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217Ab0BKVpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 16:45:41 -0500
Received: from smtp-out.google.com ([216.239.33.17]:47464 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108Ab0BKVpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 16:45:38 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Zwj3Gt7CV2bo2Ejj5oLXRaXHEqdwuaUvfbfuVVNjqJcKqSxJk9tQ4j9pIFFfOCli6
	bZ7fdOFS/XKt8OYYEKDhA==
Date: Thu, 11 Feb 2010 13:45:32 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       haicheng.li@intel.com
Subject: Re: [PATCH] [4/4] SLAB: Fix node add timer race in cache_reap
In-Reply-To: <20100211205404.085FEB1978@basil.firstfloor.org>
Message-ID: <alpine.DEB.2.00.1002111345210.8809@chino.kir.corp.google.com>
References: <20100211953.850854588@firstfloor.org> <20100211205404.085FEB1978@basil.firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010, Andi Kleen wrote:

> 
> cache_reap can run before the node is set up and then reference a NULL 
> l3 list. Check for this explicitely and just continue. The node
> will be eventually set up.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Acked-by: David Rientjes <rientjes@google.com>
