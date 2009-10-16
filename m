Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbZJPSde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbZJPSde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 14:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbZJPSde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 14:33:34 -0400
Received: from smtp-out.google.com ([216.239.45.13]:20210 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbZJPSdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 14:33:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=M18OWYsJg+mBM6WnBlj4JFf7K+m+7iCkD8h2w+pBnOUpaACnPR6BsQY0rPAgkqS1F
	vKwl8/CJZQcIY/EhhwDjQ==
Date: Fri, 16 Oct 2009 11:33:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slub: allow stats to be cleared
In-Reply-To: <alpine.DEB.1.10.0910161249100.6120@gentwo.org>
Message-ID: <alpine.DEB.1.00.0910161129320.21328@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0910150215320.1551@chino.kir.corp.google.com> <alpine.DEB.1.10.0910161249100.6120@gentwo.org>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Oct 2009, Christoph Lameter wrote:

> 
> So writing to any file clears all counters? The documentation does not say
> so.
> 

No, it just clears that particular statistic.

On a semi-related topic, it would have been nice to isolate all statistic 
files to its own directory: /sys/kernel/slab/kmalloc-256/stats/..., for 
example.  It would have made collecting (and now clearing) all statistics 
much easier since userspace wouldn't need a predefined list of stat file 
names to scan.  I wonder if Pekka would allow them to be moved...
