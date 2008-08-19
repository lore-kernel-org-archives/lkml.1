Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbYHSEnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbYHSEnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 00:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbYHSEnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 00:43:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751355AbYHSEnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 00:43:21 -0400
Date: Mon, 18 Aug 2008 21:43:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Octavian Purdila <opurdila@ixiacom.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] splice: add ->splice_read support for /dev/zero
Message-Id: <20080818214318.7142ae3e.akpm@linux-foundation.org>
In-Reply-To: <1218074455-17901-1-git-send-email-opurdila@ixiacom.com>
References: <1218074455-17901-1-git-send-email-opurdila@ixiacom.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  7 Aug 2008 05:00:55 +0300 Octavian Purdila <opurdila@ixiacom.com> wrote:

> Useful for testing.
> 
> Preallocating the zero page is simpler and faster with the relatively
> small (?) drawback of using an extra page of memory.

How much faster is it?  What workloads/benchmarks/etc?

> Maybe when CONFIG_EMBEDED is selected we can switch to dynamically
> allocating the page?
> 

One more page won't kill us.  People might want one-page-per-node, too.
But that all depends on what the benefits and applications of this are..

