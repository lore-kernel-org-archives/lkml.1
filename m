Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbZCFI21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbZCFI21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 03:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754604AbZCFI2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 03:28:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:53733 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464AbZCFI2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 03:28:13 -0500
Subject: Re: [patch 2/2] lockdep: initialize lockdep debugging statistics
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0903051355010.25505@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903050222160.30401@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0903050223240.30401@chino.kir.corp.google.com>
	 <1236250159.4228.186.camel@laptop> <20090305110522.GI32407@elte.hu>
	 <alpine.DEB.2.00.0903051355010.25505@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 09:28:03 +0100
Message-Id: <1236328083.5187.1213.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-05 at 13:57 -0800, David Rientjes wrote:
> It shouldn't be dropped, the initialization is necessary because we can't 
> rely on atomic_t's implementation.

I'm a bit slow, please use more words and explain this to me.

Before replying please read:

ea435467500612636f8f4fb639ff6e76b2496e4b

and stare at the output of:

git grep "define[ \t]*ATOMIC_INIT\>"


