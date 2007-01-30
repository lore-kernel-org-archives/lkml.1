Return-Path: <linux-kernel-owner+w=401wt.eu-S965386AbXA3P5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965386AbXA3P5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 10:57:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965308AbXA3P5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 10:57:36 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:22232 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965404AbXA3P5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 10:57:35 -0500
Message-ID: <45BF6AEB.10408@tls.msk.ru>
Date: Tue, 30 Jan 2007 18:57:31 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@osdl.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: bug reading /proc/sys/kernel/*: only first byte read.
References: <4538C47B.9060808@tls.msk.ru>	<20070130022457.d0159eba.akpm@osdl.org>	<20070130132559.GA315@tv-sign.ru> <20070130140015.GA123@tv-sign.ru> <m1y7nkh7so.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1y7nkh7so.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.94.1.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
[]
> However as far as I can tell the code has this limitation
> deliberately for simplicity.
> 
> Getting the string side of this fixed even by itself is
> worthwhile, although it might be worth teach people
> about sys_uname and /bin/uname.  It seems is the biggest thing
> people look at /proc/sys/ for...

I come across this very issue when I discovered another bug,
using un-initialized pipefs structures during early hotplug
calls.  I know about /bin/uname, but it requires a pipe, so
wont work.  Obvious alternative is /proc/sys/version, which
is alot faster too (no fork+exec overhead).

/mjt
