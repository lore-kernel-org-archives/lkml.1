Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbYCZGTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbYCZGTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 02:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbYCZGSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 02:18:54 -0400
Received: from mail.gmx.net ([213.165.64.20]:36326 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752074AbYCZGSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 02:18:53 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/zBFICZj3zbLk3jVeRCz8brF1B8ZsIudMBIoVohc
	RTjoGEG2YXT9TY
Subject: Re: Scalability requirements for sysv ipc
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Manfred Spraul <manfred@colorfullife.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       paulmck@linux.vnet.ibm.com, Nadia Derbey <Nadia.Derbey@bull.net>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1206461630.8514.441.camel@twins>
References: <47E382DB.70503@colorfullife.com> <47E3ADE3.4030304@bull.net>
	 <47E3B924.3000304@colorfullife.com>
	 <20080321141339.GB9618@linux.vnet.ibm.com>
	 <47E3DD8C.4000904@colorfullife.com>
	 <1206164608.3659.11.camel@marge.simson.net>
	 <47E4DB06.3020003@colorfullife.com>
	 <1206186832.4545.1.camel@marge.simson.net>
	 <47E51637.8060102@colorfullife.com>  <47E55945.10109@colorfullife.com>
	 <1206460206.4414.21.camel@marge.simson.net>
	 <1206461630.8514.441.camel@twins>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 07:18:46 +0100
Message-Id: <1206512326.21146.0.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-03-25 at 17:13 +0100, Peter Zijlstra wrote:

> > ...and I verified it via :-/ echo 7 > sched_features in latest.  That
> > only bought me roughly half though, so there's a part three in there
> > somewhere.
> 
> Ouch, I guess hrtimers are just way expensive on some hardware... 

It takes a large bite out of my P4 as well.

