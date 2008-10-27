Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557AbYJ0TLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbYJ0TLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 15:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbYJ0TLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 15:11:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:36042 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751281AbYJ0TLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 15:11:39 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+g2Vsh/RGguY+900AopPnZISMblUnUzaPzYtJ/h8
	FuriJVxNDpXoc7
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
From: Mike Galbraith <efault@gmx.de>
To: Rick Jones <rick.jones2@hp.com>
Cc: David Miller <davem@davemloft.net>, rjw@sisk.pl, mingo@elte.hu,
       s0mbre@tservice.net.ru, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <4905F9BD.100@hp.com>
References: <1224905848.5161.27.camel@marge.simson.net>
	 <20081024.221653.23695396.davem@davemloft.net>
	 <1224914333.3822.18.camel@marge.simson.net>
	 <20081025.001940.251852864.davem@davemloft.net>
	 <1224919985.5373.10.camel@marge.simson.net>  <4905F9BD.100@hp.com>
Content-Type: text/plain
Date: Mon, 27 Oct 2008 20:11:30 +0100
Message-Id: <1225134690.4942.11.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 10:26 -0700, Rick Jones wrote:
> Mike Galbraith wrote:
> > That's exactly what I've been trying to look into, but combined with
> > netperf.  The thing is an incredibly twisted maze of _this_ affects
> > _that_... sometimes involving magic and/or mythical creatures.
> 
> I cannot guarantee it will help, but the global -T option to pin netperf 
> or netserver to a specific CPU might help cut-down the variables.

Yup, and how.  Early on, the other variables drove me bat-shit frigging
_nuts_.  I eventually selected a UP config to test _because_ those other
variables combined with SMP overhead and config options drove crazy ;-) 

> FWIW netperf top of trunk omni tests can now also determine and report 
> the state of SELinux.  They also have code to accept or generate their 
> own RFC4122-esque UUID.  Define some connical tests and then ever closer 
> to just needing some database-fu and automagic testing I suppose... 
> things I do not presently posess but am curious enough to follow some 
> pointers.

Hrm. I'm going to have to save that, and parse a few times. (usual)

> happy benchmarking,

Not really, but I can't seem to give up ;-)

	-Mike

