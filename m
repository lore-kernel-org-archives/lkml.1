Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbZFCT1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbZFCT1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 15:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbZFCT1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 15:27:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750968AbZFCT1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 15:27:39 -0400
Date: Wed, 3 Jun 2009 12:27:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: davidel@xmailserver.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] epoll - send POLLHUP on ->release
Message-Id: <20090603122739.c53b1d1f.akpm@linux-foundation.org>
In-Reply-To: <4A26CCFA.7050105@novell.com>
References: <alpine.DEB.1.10.0906031153471.18001@makko.or.mcafeemobile.com>
	<4A26CCFA.7050105@novell.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Jun 2009 15:20:26 -0400
Gregory Haskins <ghaskins@novell.com> wrote:

> Davide Libenzi wrote:
> > The following patch allows waiters to be notified about the eventfd file* 
> > going away, and give them a change to unregister from the wait queue.
> > This is turn allows eventfd users to use the eventfd file* w/out 
> > holding a live reference to it.
> > After the eventfd user callbacks returns, any usage of the eventfd file* 
> > should be dropped. The eventfd user callback can acquire sleepy locks 
> > since it is invoked lockless.
> >
> >
> >
> > Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
> >   
> 
> Tested-by: Gregory Haskins <ghaskins@novell.com>

Confused.  Did you test this with some new kernel patch, or with some
existing kernel code?

If the latter, what code are we talking about here and what was the test
case and what went wrong when using the current mainline
implementation?

