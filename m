Return-Path: <linux-kernel-owner+w=401wt.eu-S933827AbYBMW4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933827AbYBMW4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758113AbYBMWz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:55:58 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:47022 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbYBMWz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:55:56 -0500
Date: Wed, 13 Feb 2008 14:55:55 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: David Miller <davem@davemloft.net>, shemminger@vyatta.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fib_trie: rcu_assign_pointer warning fix
Message-ID: <20080213225555.GN12393@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080211.171645.74019568.davem@davemloft.net> <20080212085714.GB2582@ff.dom.local> <20080212160729.GA9157@linux.vnet.ibm.com> <20080212193218.GA2803@ami.dom.local> <20080212194630.GB2803@ami.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212194630.GB2803@ami.dom.local>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 08:46:30PM +0100, Jarek Poplawski wrote:
> On Tue, Feb 12, 2008 at 08:32:18PM +0100, Jarek Poplawski wrote:
> ...
> > It seems the above version of this macro uses the barrier for 0, but
> > if I miss something, or for these other: documenting reasons,
> 
> ...or __builtin_constants could be used for indexing (?!),

Yep.  For example:

	elem[0].next = 1;
	rcu_assign_index(global_index, 0);

							Thanx, Paul

> > then of
> > course you are right.
> 
> Jarek P.
