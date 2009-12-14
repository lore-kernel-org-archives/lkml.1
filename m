Return-Path: <linux-kernel-owner+w=401wt.eu-S932913AbZLNXP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913AbZLNXP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932698AbZLNXP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:15:26 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42803 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932677AbZLNXPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:15:24 -0500
Date: Mon, 14 Dec 2009 15:15:23 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: mroos@linux.ee, linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: RCU detected CPU 0 stall after panic on sparc64
Message-ID: <20091214231523.GH6679@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.SOC.1.00.0912121049030.26625@math.ut.ee> <20091212.014002.173528710.davem@davemloft.net> <20091214202556.GC6679@linux.vnet.ibm.com> <20091214.130201.144162604.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091214.130201.144162604.davem@davemloft.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 01:02:01PM -0800, David Miller wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Date: Mon, 14 Dec 2009 12:25:56 -0800
> 
> > Hmmm...  At first glance, it looks like RCU should put a notifier onto
> > the panic_notifier_list to disable this check.  Or is there some global
> > variable that I can check?
> 
> Probably the notifier works just fine.

OK, will take that approach.

							Thanx, Paul
