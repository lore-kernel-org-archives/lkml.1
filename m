Return-Path: <linux-kernel-owner+w=401wt.eu-S932893Ab0AGFFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893Ab0AGFFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 00:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248Ab0AGFFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 00:05:15 -0500
Received: from mail.gmx.net ([213.165.64.20]:40788 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750869Ab0AGFFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 00:05:13 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/7ys1LUlL72qgTrG8L+gcGQJ2FrKWdVp5BNf/sHq
	qBD76X6gG5ia7Q
Subject: Re: tools/perf: "perf record" restricted to root in latest kernel?
From: Mike Galbraith <efault@gmx.de>
To: Miles Bader <miles@gnu.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1262839723.6303.5.camel@marge.simson.net>
References: <buopr5nol26.fsf@dhlpc061.dev.necel.com>
	 <20100106205911.GC18919@ghostprotocols.net>
	 <buovdfeocht.fsf@dhlpc061.dev.necel.com>
	 <1262839723.6303.5.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 07 Jan 2010 06:05:10 +0100
Message-Id: <1262840710.6303.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 05:48 +0100, Mike Galbraith wrote:
> On Thu, 2010-01-07 at 11:49 +0900, Miles Bader wrote:
> 
> > Perhaps the newer version of perf works better with newer kernels
> 
> Yup.  Bisects back to 60ab271617cec607380099f3ed8e84916e48323b.  If
> running latest kernel, normal user can record fine.  Running 31 or 32
> kernel with latest perf though, I see the same permission error.  Not
> immediately obvious to me why reverting this commit does indeed fix it. 

Heh.  echo 0 > /proc/sys/kernel/perf_event_paranoid :)

	-Mike

