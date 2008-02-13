Return-Path: <linux-kernel-owner+w=401wt.eu-S933967AbYBMXyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933967AbYBMXyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 18:54:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763185AbYBMXxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 18:53:51 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57891 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761719AbYBMXxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 18:53:50 -0500
Date: Wed, 13 Feb 2008 15:52:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: paulmck@linux.vnet.ibm.com
Cc: "stephen.hemminger@vyatta.com"@mail.vyatta.com,
       linux-kernel@vger.kernel.org, shemminger@vyatta.com,
       davem@davemloft.net, netdev@vger.kernel.org, dipankar@in.ibm.com,
       ego@in.ibm.com, herbert@gondor.apana.org.au
Subject: Re: [PATCH 1/2] remove rcu_assign_pointer(NULL) penalty with
 type/macro safety
Message-Id: <20080213155245.455944f8.akpm@linux-foundation.org>
In-Reply-To: <20080213233744.GO12393@linux.vnet.ibm.com>
References: <20080213220024.GA30729@linux.vnet.ibm.com>
	<20080213143537.1b806790@extreme>
	<20080213224134.GK12393@linux.vnet.ibm.com>
	<20080213144233.05e860cb@extreme>
	<20080213233744.GO12393@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 15:37:44 -0800
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> Ah.  It does take a bit to get fib_trie into one's build -- allyesconfig
> doesn't cut it.

This is not good.  The sole purpose of allmodconfig and allyesconfig is for
compilation and linkage coverage testing.  Hence we should aim to get as
much code as possible included in those cases.

