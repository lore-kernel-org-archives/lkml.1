Return-Path: <linux-kernel-owner+w=401wt.eu-S1762662AbYFGQM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762662AbYFGQM1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 12:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759829AbYFGQMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 12:12:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36988 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760281AbYFGQMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 12:12:18 -0400
Subject: Re: [patch part 2] Re: [patch] Re: PostgreSQL pgbench performance
	regression in 2.6.23+
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Greg Smith <gsmith@gregsmith.com>, Ingo Molnar <mingo@elte.hu>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <1212850447.4668.10.camel@marge.simson.net>
References: <1211440207.5733.8.camel@marge.simson.net>
	 <20080522082814.GA4499@linux.vnet.ibm.com>
	 <1211447105.4823.7.camel@marge.simson.net>
	 <1211452465.7606.8.camel@marge.simson.net>
	 <1211455553.4381.9.camel@marge.simson.net>
	 <1211456659.29104.20.camel@twins>
	 <1211458176.5693.6.camel@marge.simson.net>
	 <1211459081.29104.40.camel@twins>
	 <Pine.GSO.4.64.0805230232190.28654@westnet.com>
	 <1211536814.5851.18.camel@marge.simson.net>
	 <20080523101000.GA13964@elte.hu>
	 <1211537717.5851.22.camel@marge.simson.net>
	 <Pine.GSO.4.64.0805231907150.25273@westnet.com>
	 <1211586407.4786.5.camel@marge.simson.net>
	 <Pine.GSO.4.64.0805260851510.24771@westnet.com>
	 <1211867950.5505.47.camel@marge.simson.net>
	 <Pine.GSO.4.64.0806060027290.8466@westnet.com>
	 <1212732780.13981.43.camel@marge.simson.net>
	 <1212838682.5571.6.camel@marge.simson.net>
	 <1212844084.19205.85.camel@lappy.programming.kicks-ass.net>
	 <1212850447.4668.10.camel@marge.simson.net>
Content-Type: text/plain
Date: Sat, 07 Jun 2008 18:12:00 +0200
Message-Id: <1212855120.19205.91.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-06-07 at 16:54 +0200, Mike Galbraith wrote:
> On Sat, 2008-06-07 at 15:08 +0200, Peter Zijlstra wrote:
> > On Sat, 2008-06-07 at 13:38 +0200, Mike Galbraith wrote:
> > 
> > Interesting.. Looks good.
> 
> In that case it _might_ fly, so needs changelog and blame line.

Just wondering, how much effect does the last_preempter stuff have?, it
seems to me the minimum runtime check ought to throttle these wakeups
quite a bit as well.



