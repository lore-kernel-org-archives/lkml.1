Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbZCEKts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbZCEKts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 05:49:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755619AbZCEKtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 05:49:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46661 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570AbZCEKtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 05:49:32 -0500
Subject: Re: [patch 2/2] lockdep: initialize lockdep debugging statistics
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0903050223240.30401@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903050222160.30401@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0903050223240.30401@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 11:49:19 +0100
Message-Id: <1236250159.4228.186.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-05 at 02:29 -0800, David Rientjes wrote:
> The CONFIG_DEBUG_LOCKDEP statistics need to be initialized with
> ATOMIC_INIT(0) since they are of type atomic_t.

And how does ATOMIC_INIT(0) differ from the global/static storage being
initialized to 0?

All I can see this doing it moving the variables from bss to data for
some compilers.

