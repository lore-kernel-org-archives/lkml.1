Return-Path: <linux-kernel-owner+w=401wt.eu-S934262AbYBMX5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934262AbYBMX5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 18:57:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763507AbYBMX5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 18:57:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58237
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760704AbYBMX5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 18:57:09 -0500
Date: Wed, 13 Feb 2008 15:57:38 -0800 (PST)
Message-Id: <20080213.155738.71849437.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, "stephen.hemminger@vyatta.com"@mail.vyatta.com,
       linux-kernel@vger.kernel.org, shemminger@vyatta.com,
       netdev@vger.kernel.org, dipankar@in.ibm.com, ego@in.ibm.com,
       herbert@gondor.apana.org.au
Subject: Re: [PATCH 1/2] remove rcu_assign_pointer(NULL) penalty with
 type/macro safety
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080213155245.455944f8.akpm@linux-foundation.org>
References: <20080213144233.05e860cb@extreme>
	<20080213233744.GO12393@linux.vnet.ibm.com>
	<20080213155245.455944f8.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 13 Feb 2008 15:52:45 -0800

> On Wed, 13 Feb 2008 15:37:44 -0800
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Ah.  It does take a bit to get fib_trie into one's build -- allyesconfig
> > doesn't cut it.
> 
> This is not good.  The sole purpose of allmodconfig and allyesconfig is for
> compilation and linkage coverage testing.  Hence we should aim to get as
> much code as possible included in those cases.

Well, in this case there is a choice, either you use one routing
lookup datastructure or the other.  It's not purposefully being hidden
from the everything builds :-)
