Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbXEJEIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbXEJEIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 00:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbXEJEHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 00:07:54 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757004AbXEJEHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 00:07:54 -0400
Date: Wed, 9 May 2007 21:07:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 5/6] UML - Monitor stack usage
Message-Id: <20070509210738.a06b005a.akpm@linux-foundation.org>
In-Reply-To: <20070509202722.GA22464@c2.user-mode-linux.org>
References: <20070509202722.GA22464@c2.user-mode-linux.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007 16:27:22 -0400 Jeff Dike <jdike@addtoit.com> wrote:

> In preparation for reducing stack size, add a machanism to see how
> much of a kernel stack is used.  This fills a new stack with 0x6b on
> allocation and sees where the lowest non-0x6b byte is on process
> exit.  It keeps track of the lowest value and logs values as they get
> lower.

but, but.  We already have CONFIG_DEBUG_STACK_USAGE?
