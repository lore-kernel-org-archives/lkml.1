Return-Path: <linux-kernel-owner+w=401wt.eu-S1759823AbZFWQkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759823AbZFWQkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbZFWQkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:40:39 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:43483 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZFWQki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:40:38 -0400
Date: Wed, 24 Jun 2009 01:39:40 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       niv@us.ibm.com, dvhltc@us.ibm.com, dhowells@redhat.com,
       kernel@wantstofly.org, matthew@wil.cx
Subject: Re: [PATCH -tip] v5 RCU: the bloatwatch edition
Message-ID: <20090623163939.GE26674@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org, mingo@elte.hu,
	akpm@linux-foundation.org, niv@us.ibm.com, dvhltc@us.ibm.com,
	dhowells@redhat.com, kernel@wantstofly.org, matthew@wil.cx
References: <20090623042442.GA15630@linux.vnet.ibm.com> <20090623161217.GA15298@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623161217.GA15298@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 09:12:17AM -0700, Paul E. McKenney wrote:
> This patch is a -tip version of RCU designed for (!SMP && EMBEDDED)
> provided as a proof of concept of a small-footprint RCU implementation.
> In particular, the implementation of synchronize_rcu() is extremely
> lightweight and high performance.  It passes rcutorture testing in each
> of the four relevant configurations (combinations of NO_HZ and PREEMPT)
> on x86.  This saves 1263 bytes compared to Classic RCU, and more than
> three kilobytes compared to Hierarchical RCU (updated to 2.6.30):
> 
[snip]

> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Acked-by: David Howells <dhowells@redhat.com>

Acked-by: Paul Mundt <lethal@linux-sh.org>
