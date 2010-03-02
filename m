Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab0CBLjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 06:39:47 -0500
Received: from mail.gmx.net ([213.165.64.20]:36121 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750776Ab0CBLjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 06:39:46 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+M4UFO3zSMLfYzNPM8RZkbm+2WikW2cIpgm+TLQ3
	GnoJ3jPjDFSDZI
Subject: Re: [rfc/rft][patch] should use scheduler sync hint in
 tcp_prequeue()?
From: Mike Galbraith <efault@gmx.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1267529273.2964.111.camel@edumazet-laptop>
References: <1267522901.25906.101.camel@marge.simson.net>
	 <1267529273.2964.111.camel@edumazet-laptop>
Content-Type: text/plain
Date: Tue, 02 Mar 2010 12:39:42 +0100
Message-Id: <1267529982.9365.7.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.66000000000000003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-02 at 12:27 +0100, Eric Dumazet wrote:

> This wake_up_interruptible_sync_poll() change might be good for loopback
> communications (and pleases tbench), but is it desirable for regular
> multi flows NIC traffic ?

If you can take high frequency cache misses, likely yes.  For localhost,
that's pretty much guaranteed currently (ergo the question).

	-Mike

