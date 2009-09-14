Return-Path: <linux-kernel-owner+w=401wt.eu-S1750994AbZINGPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750994AbZINGPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 02:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750749AbZINGPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 02:15:43 -0400
Received: from mail.gmx.net ([213.165.64.20]:59845 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750739AbZINGPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 02:15:42 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19wJWt4r/hwTUA5oEEHg1p7271xo+VFjQfilPwcXC
	V3/tmzKLMScCdo
Subject: Re: Epic regression in throughput since v2.6.23
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1252869472.14621.24.camel@marge.simson.net>
References: <20090906205952.GA6516@elte.hu>
	 <87hbvdiogq.fsf@depni.sinp.msu.ru> <873a6xdqwq.fsf@depni.sinp.msu.ru>
	 <20090909155223.GA12065@elte.hu> <87my53vo6d.fsf@depni.sinp.msu.ru>
	 <20090910065306.GB3920@elte.hu> <87ljkm9yew.fsf@depni.sinp.msu.ru>
	 <20090911061024.GA27833@elte.hu> <87iqfmx3tr.fsf@depni.sinp.msu.ru>
	 <20090913154744.GA27066@elte.hu>
	 <1252869472.14621.24.camel@marge.simson.net>
Content-Type: text/plain
Date: Mon, 14 Sep 2009 08:15:42 +0200
Message-Id: <1252908942.19686.15.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-13 at 21:17 +0200, Mike Galbraith wrote:

> Anyway, I'm thinking of tracking forks/sec as a means of detecting the
> fork/exec load.  Or, maybe just enable it when there's > 1 buddy pair
> running.. or something.  After all, NEXT_BUDDY is about scalability, and
> make -j4 on a quad surely doesn't need any scalability help :)

But, this buddy vs fork/exec thing is not at all cut and dried.  Even
with fork/exec load being the primary CPU consumer, there are genuine
buddies to worry about when you've got a GUI running, next/last buddy
can reduce the chances that an oinker slips in between X and client.

Ponder...

(oil for rusty old ponder machine welcome, gears grinding)

	-Mike

