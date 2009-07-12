Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbZGLWuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbZGLWuP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 18:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbZGLWuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 18:50:04 -0400
Received: from smtp-out.google.com ([216.239.33.17]:39813 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbZGLWuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 18:50:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=fzfHsZ92AT8WhNkMyLMmssFF14b1HzODEnD51SGwKpwErVTnOIgULnc/4Eqjf/CHb
	CC5/SGbWR/FROfDY2z3OA==
Date: Sun, 12 Jul 2009 15:49:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg KH <greg@kroah.com>
cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] STAGING fixes for 2.6.31-rc2-git tree
In-Reply-To: <20090712223726.GC16600@kroah.com>
Message-ID: <alpine.DEB.2.00.0907121543130.8327@chino.kir.corp.google.com>
References: <20090712223726.GC16600@kroah.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jul 2009, Greg KH wrote:

> Here are a few patches for the drivers/staging/ section of the kernel,
> for your git tree.
> 
> The majority are fixes for things that people have reported, and now
> there should not be any build errors for this portion of the tree.  If
> anyone still has any problems, please let me know.
> 

I do, the patch entitled "Staging: android: lowmemorykiller.c: fix it for 
'oom: move oom_adj value from task_struct to mm_struct'" was added to 
gregkh-2.6 on July 2 and still hasn't made it to Linus' tree.  That has 
caused a CONFIG_ANDROID_LOW_MEMORY_KILLER build failure for the last month 
which I explicitly warned about over two months ago:

	http://marc.info/?l=linux-kernel&m=124207736216807
