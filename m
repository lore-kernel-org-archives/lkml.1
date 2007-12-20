Return-Path: <linux-kernel-owner+w=401wt.eu-S1763505AbXLTMQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763505AbXLTMQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763164AbXLTMMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:12:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57175
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1763147AbXLTMMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:12:08 -0500
Date: Thu, 20 Dec 2007 04:12:07 -0800 (PST)
Message-Id: <20071220.041207.64671626.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: kuznet@ms2.inr.ac.ru, wangchen@cn.fujitsu.com, gerrit@erg.abdn.ac.uk,
       andi@firstfloor.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, clameter@sgi.com, mingo@elte.hu
Subject: Re: [PATCH 3/3] [UDP6]: Counter increment on BH mode
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071215135851.GA29063@gondor.apana.org.au>
References: <20071203115435.GA4202@gondor.apana.org.au>
	<20071203131723.GA30312@gondor.apana.org.au>
	<20071215135851.GA29063@gondor.apana.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Sat, 15 Dec 2007 21:58:52 +0800

> [SNMP]: Fix SNMP counters with PREEMPT
> 
> The SNMP macros use raw_smp_processor_id() in process context
> which is illegal because the process may be preempted and then
> migrated to another CPU.
> 
> This patch makes it use get_cpu/put_cpu to disable preemption.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Applied to net-2.6.25, thanks.
