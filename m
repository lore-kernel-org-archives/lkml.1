Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbZJDSYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbZJDSYl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 14:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbZJDSYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 14:24:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:45488 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752464AbZJDSYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 14:24:40 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/xlM0Zd3fxdN/3+XgB5zvY1FmFpXtXkMiryMZoyg
	VM+W8e5gjs6zB4
Subject: Re: Do not overload dispatch queue (Was: Re: IO scheduler based IO
 controller V10)
From: Mike Galbraith <efault@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       riel@redhat.com
In-Reply-To: <20091004173901.GD26573@kernel.dk>
References: <1254578553.7499.5.camel@marge.simson.net>
	 <20091003142840.GE31616@kernel.dk>
	 <1254581496.8293.8.camel@marge.simson.net>
	 <20091003151445.GF31616@kernel.dk>
	 <1254585420.7539.2.camel@marge.simson.net>
	 <20091003173532.GG31616@kernel.dk>
	 <1254596864.7153.9.camel@marge.simson.net>
	 <20091003192321.GA26573@kernel.dk>
	 <1254599386.7153.46.camel@marge.simson.net>
	 <1254653434.7237.18.camel@marge.simson.net>
	 <20091004173901.GD26573@kernel.dk>
Content-Type: text/plain
Date: Sun, 04 Oct 2009 20:23:42 +0200
Message-Id: <1254680622.27889.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-10-04 at 19:39 +0200, Jens Axboe wrote:

> So I'll commit a change that doesn't do the delay at all, basically it
> just offset the current code by one slice.

Ok, when it hits block-for-linus, I'll take it out for a spin.

	-Mike

