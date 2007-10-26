Return-Path: <linux-kernel-owner+w=401wt.eu-S1762421AbXJZJov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762421AbXJZJov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 05:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757777AbXJZJnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 05:43:42 -0400
Received: from smtp-out.google.com ([216.239.45.13]:40438 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762323AbXJZJnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 05:43:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=tUy7MFS5FZZggbHfbDcVs3zPXe+LlzDPZcrB+xTZvxmEHXMFELx37c1eNQMG+vN3Y
	tWOkPhpIbsX3muZj3fm3w==
Date: Fri, 26 Oct 2007 02:42:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alexey Dobriyan <adobriyan@sw.ru>
cc: torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] De-constify sched.h
In-Reply-To: <20071026081721.GA6244@localhost.sw.ru>
Message-ID: <alpine.DEB.0.9999.0710260235130.8261@chino.kir.corp.google.com>
References: <20071026081721.GA6244@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007, Alexey Dobriyan wrote:

> 2) There is no such thing as const task_struct. Anyone who think otherwise
>    deserves compiler warning.
> 

A 'const struct task_struct *' can be used as an annotation to mean that 
no member of the struct is modified through that pointer, so it's 
perfectly acceptable to qualify formals in that manner.
