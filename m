Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbYGYIbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbYGYIbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 04:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYGYIbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 04:31:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:40715 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbYGYIbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 04:31:22 -0400
Subject: Re: [PATCH 2/2][RT] powerpc - Make the irq reverse mapping radix
	tree lockless
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sebastien Dugue <sebastien.dugue@bull.net>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux-rt <linux-rt-users@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Tim Chavez <tinytim@us.ibm.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Gilles Carry <Gilles.Carry@ext.bull.net>
In-Reply-To: <1216972177.7257.351.camel@twins>
References: <20080724122352.3bc76bda@bull.net>
	 <20080724125044.53b604cb@bull.net>
	 <200807242111.35338.nickpiggin@yahoo.com.au>
	 <20080724141839.477de30b@bull.net>  <1216972177.7257.351.camel@twins>
Content-Type: text/plain
Date: Fri, 25 Jul 2008 18:27:20 +1000
Message-Id: <1216974440.11188.100.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-25 at 09:49 +0200, Peter Zijlstra wrote:
> 
> 
> The only advantage of the concurrent radix tree over this model is that
> it can potentially do multiple modification operations at the same time.

Yup, we do not need that for the irq revmap... concurrent lookup is all we need.

Cheers,
Ben.


