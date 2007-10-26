Return-Path: <linux-kernel-owner+w=401wt.eu-S1762078AbXJZJug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762078AbXJZJug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 05:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbXJZJu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 05:50:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49756
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751287AbXJZJu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 05:50:28 -0400
Date: Fri, 26 Oct 2007 02:50:29 -0700 (PDT)
Message-Id: <20071026.025029.00497274.davem@davemloft.net>
To: rientjes@google.com
Cc: adobriyan@sw.ru, torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] De-constify sched.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.0.9999.0710260235130.8261@chino.kir.corp.google.com>
References: <20071026081721.GA6244@localhost.sw.ru>
	<alpine.DEB.0.9999.0710260235130.8261@chino.kir.corp.google.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>
Date: Fri, 26 Oct 2007 02:42:30 -0700 (PDT)

> On Fri, 26 Oct 2007, Alexey Dobriyan wrote:
> 
> > 2) There is no such thing as const task_struct. Anyone who think otherwise
> >    deserves compiler warning.
> > 
> 
> A 'const struct task_struct *' can be used as an annotation to mean that 
> no member of the struct is modified through that pointer, so it's 
> perfectly acceptable to qualify formals in that manner.

But in one of the cases he un-const's the code does modify
the object through the pointer.  At least that one should
be reverted since the annotation is wrong.
