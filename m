Return-Path: <linux-kernel-owner+w=401wt.eu-S1760494AbZFRNhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760494AbZFRNhl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 09:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754879AbZFRNhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 09:37:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36244 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684AbZFRNhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 09:37:32 -0400
Subject: Re: [PATCH 6/9 UPDATED] percpu: enforce global definition
From: Steven Rostedt <srostedt@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, kyle@mcmartin.ca, cl@linux-foundation.org,
       Jesper.Nilsson@axis.com, benh@kernel.crashing.org,
       paulmck@linux.vnet.ibm.com, David Howells <dhowells@redhat.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, arm@redhat.com
In-Reply-To: <4A39EF13.7010309@kernel.org>
References: <1245210060-24344-1-git-send-email-tj@kernel.org>
	 <1245210060-24344-7-git-send-email-tj@kernel.org>
	 <4A39EF13.7010309@kernel.org>
Content-Type: text/plain
Organization: Red Hat
Date: Thu, 18 Jun 2009 09:26:37 -0400
Message-Id: <1245331597.5195.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2009-06-18 at 16:38 +0900, Tejun Heo wrote:
> Some archs (alpha and s390) need to add 'weak' attribute to percpu
> variable definitions so that the compiler generates external
> references for them.  To allow this, enforce global definition of all
> percpu variables.
> 
> This patch makes DEFINE_PER_CPU_SECTION() do DECLARE_PERCPU_SECTION()
> implicitly and drop static from all percpu definitions.
> 
> [ Impact: all percpu variables are forced to be global ]
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Uh, wont this cause name space collisions?

-- Steve


