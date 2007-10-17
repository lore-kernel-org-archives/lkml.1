Return-Path: <linux-kernel-owner+w=401wt.eu-S932592AbXJQUlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592AbXJQUlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761603AbXJQUl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:41:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44519 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751897AbXJQUl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:41:27 -0400
Date: Wed, 17 Oct 2007 13:41:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [RFC] remove netpoll receive code
Message-Id: <20071017134124.00f5633a.akpm@linux-foundation.org>
In-Reply-To: <20071017132131.1992bedd@freepuppy.rosehill>
References: <20071017132131.1992bedd@freepuppy.rosehill>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 13:21:31 -0700
Stephen Hemminger <shemminger@linux-foundation.org> wrote:

> The netpoll receive code is:
> 1. Not used by any in-tree features, it is used by kgdb-over-ether.
> 2. A nice hook for people doing nasty things like private binary network stacks or rootkits.
> 3. Unsecured by any of the normal firewalling code.
> 
> Hopefully all distro's are smart enough to turn it off in their default config *nudge, nudge*.
> Doubly true for any distribution that claims to be secure or enterprise ready.
> 
> I propose that we take out all the whole netpoll rx path. If/when kgdb gets submitted
> a better and alternative receive path can be added.
> 

umm, let's cc the kgdb maintainer.
