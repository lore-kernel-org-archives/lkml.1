Return-Path: <linux-kernel-owner+w=401wt.eu-S932447AbYCEMfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447AbYCEMfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 07:35:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbYCEMfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 07:35:24 -0500
Received: from relay1.sgi.com ([192.48.171.29]:33895 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752134AbYCEMfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 07:35:23 -0500
Date: Wed, 5 Mar 2008 06:35:18 -0600
From: Paul Jackson <pj@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: a.p.zijlstra@chello.nl, maxk@qualcomm.com, tglx@linutronix.de,
       oleg@tv-sign.ru, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       rientjes@google.com
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
Message-Id: <20080305063518.69d03de1.pj@sgi.com>
In-Reply-To: <20080305085019.GA24097@elte.hu>
References: <1204545445.11412.6.camel@twins>
	<20080303113621.1dfdda87.pj@sgi.com>
	<1204567052.6241.4.camel@lappy>
	<20080303121033.c8c9651c.pj@sgi.com>
	<1204568316.8514.18.camel@twins>
	<20080304013534.4e51ae48.pj@sgi.com>
	<1204628762.6241.46.camel@lappy>
	<47CDA885.3000103@qualcomm.com>
	<20080304191159.a02be58b.pj@sgi.com>
	<1204706272.6241.79.camel@lappy>
	<20080305085019.GA24097@elte.hu>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo wrote:
> i always thought that cpusets should boot up with some 
> meaningful default set that people could play with.

They do ... you just have to mount cpusets to see it ;).

If your kernel is configured with CONFIG_CPUSETS, then
there is one 'top' cpuset containing all tasks, all mems,
and all cpus, setup during the kernel init boot code,
unconditionally.

Anyone who does:
	mkdir -p /dev/cpuset
	mount -t cpuset cpuset /dev/cpuset
can see it and play with it.

... perhaps I misunderstood your comment?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
