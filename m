Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbYJ1OAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbYJ1OAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 10:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYJ1OAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 10:00:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:47259 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752645AbYJ1OAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 10:00:39 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/VOZo1szHVscTgD6ansiZzn/AaQXs3ohpFpgCgmo
	CzzLj0A2qWmMKu
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, zbr@ioremap.net,
       alan@lxorguk.ukuu.org.uk, jkosina@suse.cz, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, rjw@sisk.pl, s0mbre@tservice.net.ru,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <1225191456.4903.254.camel@marge.simson.net>
References: <20081027113306.5b1d5898@lxorguk.ukuu.org.uk>
	 <20081027183312.GD11494@elte.hu> <20081027193933.GB2590@ioremap.net>
	 <20081027.124848.163119274.davem@davemloft.net>
	 <1225189462.4903.238.camel@marge.simson.net>
	 <20081028103741.GA22319@elte.hu>
	 <1225191456.4903.254.camel@marge.simson.net>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 15:00:33 +0100
Message-Id: <1225202433.4899.11.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-28 at 11:57 +0100, Mike Galbraith wrote:

> I don't know where it lives.  I'm still looking, and the numbers are
> still playing games with my head.

Hm.  _Maybe_ someone needs to take a look at c7aceab.  I took it to a 26
test tree yesterday, and it lowered my throughput, though I didn't
repeat a lot, was too busy.  I just backed it out of one of my 27 test
trees, and the netperf number is 1.030, tbench is 1.040.  I'll test this
in virgin source later, but thought I should drop a note, so perhaps
someone interested in this thread can confirm/deny loss.

	-Mike

