Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbYJaCow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbYJaCow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 22:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbYJaCon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 22:44:43 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37293 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174AbYJaCom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 22:44:42 -0400
Date: Thu, 30 Oct 2008 08:52:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rjw@sisk.pl,
       dipankar@in.ibm.com, tglx@linuxtronix.de, andi@firstfloor.org
Subject: Re: [PATCH] v3 rudimentary tracing for Classic RCU
Message-ID: <20081030155218.GA6162@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081007212215.GN6384@linux.vnet.ibm.com> <20081009010846.GA10188@linux.vnet.ibm.com> <20081010034421.GA12449@linux.vnet.ibm.com> <20081013230914.GA27467@linux.vnet.ibm.com> <49005C09.6010805@cn.fujitsu.com> <20081026215930.GC6236@linux.vnet.ibm.com> <20081027215029.GA31664@linux.vnet.ibm.com> <20081027235748.GA3647@linux.vnet.ibm.com> <20081029011633.GA21940@linux.vnet.ibm.com> <4907BCFB.8090600@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4907BCFB.8090600@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 09:31:39AM +0800, Lai Jiangshan wrote:
> Paul E. McKenney wrote:
> 
> > Ported to 2.6.27 to ease testing, and fixed up the formatting a bit.
> > I remember quickly scanning through one-line-per-CPU data to find
> > problems with rcutree.c, but the expanded names are quite nice -- I
> > had to brutally abbreviate to fit each CPU on a single line.
> > And I agree that seqfile does work nicely for this.
> > 
> > I am strongly tempted to suggest CSV format output with headers to
> > allow the data to be pulled into gnumeric or oocalc -- this would
> > make handling large numbers of CPUs much easier.  (Quickly donning
> > the asbestos suit with titanium pinstripes...)
> 
> Hi, Paul,
> 	My patch is like an example, you do not need keep the
> codes that I have wrote. you can rewrite all of it. these files
> are only accessed by RCU guys, not users. and some file in /proc
> is very simple but easy to be read: /proc/stat, /proc/loadavg.

Hello, Jiangshan,

Good point -- I do very much appreciate the seqfile tutorial!!!

						Thanx, Paul
