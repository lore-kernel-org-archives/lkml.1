Return-Path: <linux-kernel-owner+w=401wt.eu-S1760128AbXEQAu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128AbXEQAu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 20:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757264AbXEQAus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 20:50:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:49691 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756359AbXEQAur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 20:50:47 -0400
Subject: Re: Resending: RT patches expose netdev race [was Re: [RFC] [patch
	2/2] powerpc 2.6.21-rt1: fix kernel hang and/or panic
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linas Vepstas <linas@austin.ibm.com>
Cc: Tsutomu OWA <tsutomu.owa@toshiba.co.jp>, linuxppc-dev@ozlabs.org,
       mingo@elte.hu, tglx@linutronix.de, cbe-oss-dev@ozlabs.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070517002751.GC4325@austin.ibm.com>
References: <20070517002751.GC4325@austin.ibm.com>
Content-Type: text/plain
Date: Thu, 17 May 2007 10:49:45 +1000
Message-Id: <1179362985.32247.252.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I do not know why sk_buff->head would be null, or
> would be set in a racy kind of way, or why the rt patches
> would cause this. But the evidence implicates that.

Would it be possible that a locking bug in spidernet would cause it
under some circumstances to get a stale skb pointer ?

Ben.


