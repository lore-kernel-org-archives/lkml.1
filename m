Return-Path: <linux-kernel-owner+w=401wt.eu-S935759AbYCFSTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935759AbYCFSTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 13:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbYCFSTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 13:19:05 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:4917 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbYCFSTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 13:19:04 -0500
Subject: Re: [BUG] 2.6.25-rc4 hang/softlockups after freeing hugepages
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Adam Litke <agl@us.ibm.com>, Nishanth Aravamudan <nacc@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Eric Whitney <eric.whitney@hp.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080306174520.GA29047@elte.hu>
References: <1204824183.5294.62.camel@localhost>
	 <20080306174520.GA29047@elte.hu>
Content-Type: text/plain
Organization: HP/OSLO
Date: Thu, 06 Mar 2008 13:19:13 -0500
Message-Id: <1204827553.5294.80.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-06 at 18:45 +0100, Ingo Molnar wrote:
> * Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> 
> > Test platform: HP Proliant DL585 server - 4 socket, dual core AMD with 
> > 32GB memory.
> 
> does the patch below change the problem in any way? (it fixes a rare 
> hugetlbfs related memory leak)

I'll try it.  I didn't actually fault in any hugepages in my last test,
so I wouldn't have expected page tables to be involved.  I'll let you
know.

Lee


