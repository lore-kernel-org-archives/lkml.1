Return-Path: <linux-kernel-owner+w=401wt.eu-S1753667AbYJ2BfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbYJ2BfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 21:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbYJ2Bey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 21:34:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60670 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbYJ2Bey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 21:34:54 -0400
Message-ID: <4907BCFB.8090600@cn.fujitsu.com>
Date: Wed, 29 Oct 2008 09:31:39 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, rjw@sisk.pl,
       dipankar@in.ibm.com, tglx@linuxtronix.de, andi@firstfloor.org
Subject: Re: [PATCH] v3 rudimentary tracing for Classic RCU
References: <20081007163401.GJ6384@linux.vnet.ibm.com> <20081007210947.GP20740@one.firstfloor.org> <20081007212215.GN6384@linux.vnet.ibm.com> <20081009010846.GA10188@linux.vnet.ibm.com> <20081010034421.GA12449@linux.vnet.ibm.com> <20081013230914.GA27467@linux.vnet.ibm.com> <49005C09.6010805@cn.fujitsu.com> <20081026215930.GC6236@linux.vnet.ibm.com> <20081027215029.GA31664@linux.vnet.ibm.com> <20081027235748.GA3647@linux.vnet.ibm.com> <20081029011633.GA21940@linux.vnet.ibm.com>
In-Reply-To: <20081029011633.GA21940@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:

> Ported to 2.6.27 to ease testing, and fixed up the formatting a bit.
> I remember quickly scanning through one-line-per-CPU data to find
> problems with rcutree.c, but the expanded names are quite nice -- I
> had to brutally abbreviate to fit each CPU on a single line.
> And I agree that seqfile does work nicely for this.
> 
> I am strongly tempted to suggest CSV format output with headers to
> allow the data to be pulled into gnumeric or oocalc -- this would
> make handling large numbers of CPUs much easier.  (Quickly donning
> the asbestos suit with titanium pinstripes...)
> 
> 							Thanx, Paul
> 
> 

Hi, Paul,
	My patch is like an example, you do not need keep the
codes that I have wrote. you can rewrite all of it. these files
are only accessed by RCU guys, not users. and some file in /proc
is very simple but easy to be read: /proc/stat, /proc/loadavg.

			Thanx, Lai.


