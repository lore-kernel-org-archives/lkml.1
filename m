Return-Path: <linux-kernel-owner+w=401wt.eu-S1756969AbZJLOeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969AbZJLOeq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756605AbZJLOep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:34:45 -0400
Received: from mail.gmx.net ([213.165.64.20]:57538 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756382AbZJLOep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:34:45 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18on3QeQ+koHwM2ozr3Vgq0aKwehq7JxCz0tFsMhx
	OTuEA6Y0PowDNE
Subject: Re: hackbench regression with kernel 2.6.32-rc1
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1255357264.10420.15.camel@twins>
References: <1255079943.25078.23.camel@ymzhang>
	 <1255084986.8802.46.camel@laptop>  <1255331120.3684.43.camel@ymzhang>
	 <1255357264.10420.15.camel@twins>
Content-Type: text/plain
Date: Mon, 12 Oct 2009 16:33:52 +0200
Message-Id: <1255358032.6818.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 16:21 +0200, Peter Zijlstra wrote:

> Mike, did we ever figure out _why_ NEXT_BUDDY introduced latencies?

No, I haven't gotten around to poking at that yet.  I'll try that x264
thing, IIRC, NEXT_BUDDY hurt it pretty badly.

> Buddies shouldn't make latencies worse than regular while(1); loops
> would.

Yeah, no idea what's going wrong.

	-Mike

