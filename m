Return-Path: <linux-kernel-owner+w=401wt.eu-S1752247AbZCJDRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbZCJDRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 23:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbZCJDRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 23:17:12 -0400
Received: from mail.gmx.net ([213.165.64.20]:60320 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752044AbZCJDRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 23:17:11 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19kTbwCMIVkFU5Qw5Xq2Jvr8JuObDTqdaj95j6Spc
	uXBjuiuL8DGd5f
Subject: Re: [patch] Re: scheduler oddity [bug?]
From: Mike Galbraith <efault@gmx.de>
To: Balazs Scheidler <bazsi@balabit.hu>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Willy Tarreau <w@1wt.eu>
In-Reply-To: <1236614243.8114.8.camel@bzorp.balabit>
References: <1236448069.16726.21.camel@bzorp.balabit>
	 <1236505323.6281.57.camel@marge.simson.net>
	 <1236506309.6972.8.camel@marge.simson.net> <20090308153956.GB19658@elte.hu>
	 <1236529200.7110.16.camel@marge.simson.net>
	 <20090308175255.GA22802@elte.hu>
	 <1236585731.6118.24.camel@marge.simson.net>
	 <1236614243.8114.8.camel@bzorp.balabit>
Content-Type: text/plain
Date: Tue, 10 Mar 2009 04:16:44 +0100
Message-Id: <1236655004.5672.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-09 at 16:57 +0100, Balazs Scheidler wrote:
> Hi,
> 
> Just an interesting sidenote:
> 
> I've ported the quoted patch and
> 38736f475071b80b66be28af7b44c854073699cc  (the one I've found via
> bisect) to 2.6.27 but these didn't resolve my scheduling problem, both
> my test program and my application still uses only one CPU. So probably
> the rest of the scheduling patches between 2.6.27..2.6.28 have some
> effect too.

It's probably the changes to wake_affine().  27 doesn't have the disable
sync if avg_overlap is too large tests.

	-Mike

