Return-Path: <linux-kernel-owner+w=401wt.eu-S934318AbYB2WAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934318AbYB2WAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 17:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933121AbYB2WAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 17:00:33 -0500
Received: from relay2.sgi.com ([192.48.171.30]:46181 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932635AbYB2WAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 17:00:32 -0500
Date: Fri, 29 Feb 2008 16:00:28 -0600
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org, rientjes@google.com,
       "Paul Menage" <menage@google.com>
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
Message-Id: <20080229160028.b54babbe.pj@sgi.com>
In-Reply-To: <47C87C28.2010606@qualcomm.com>
References: <20080227222103.673194000@chello.nl>
	<1204311351.6243.130.camel@lappy>
	<20080229145516.4d96aeaa.pj@sgi.com>
	<1204319674.6243.145.camel@lappy>
	<47C87C28.2010606@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max wrote:
> Yeah, I'd prefer it to be along with cpusets. As I mentioned will need similar 
> mechanisms for other things besides irqs for complete isolation. Creating a 
> separate group for each sounds like an overkill.

One can combine cgroups into a single hierarchy.

If we had irqs and these similar mechanisms you have in mind each in
their separate cgroup subsystem, and if you normally wanted to deal
with them all in a single hierarchy, then you can mount those cgroup
subsystems together.

I've manage to avoid learning how to use cgroups, so you might want
to ask Paul Menage (just added to the cc list) how to do that, if the
Documentation/cgroups.txt isn't sufficient.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
