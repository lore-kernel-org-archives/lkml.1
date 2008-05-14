Return-Path: <linux-kernel-owner+w=401wt.eu-S1752385AbYENUdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbYENUdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 16:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbYENUc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 16:32:56 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:49078 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbYENUcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 16:32:55 -0400
Date: Wed, 14 May 2008 13:32:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, davem@davemloft.net,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.26-rc2-mm1 - kernel panic at inet_create() on powerpc
Message-ID: <20080514203251.GF8812@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080514010129.4f672378.akpm@linux-foundation.org> <482B066F.4010605@linux.vnet.ibm.com> <20080514160705.GB8812@linux.vnet.ibm.com> <20080514200546.GA4802@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514200546.GA4802@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 12:05:46AM +0400, Alexey Dobriyan wrote:
> On Wed, May 14, 2008 at 09:07:05AM -0700, Paul E. McKenney wrote:
> > On Wed, May 14, 2008 at 09:04:07PM +0530, Kamalesh Babulal wrote:
> > > Hi Andrew,
> > > 
> > > 2.6.26-rc2-mm1 kernel panics on powerpc, while running ltp test over it.
> > > I have attached the gdb output of the pc and lr registers. The patch
> > > list_for_each_rcu-must-die-networking.patch points to changes made 
> > > to the same lines listed by the gdb output.
> > 
> > Hmmm....  Does the panic go away when this patch is reverted?
> 
> Yes.

OK, am awake now, apologies for my confusion.  Not sure -what- state
I was in when generating and validating the original...

							Thanx, Paul
