Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbZJBSWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbZJBSWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 14:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbZJBSWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 14:22:37 -0400
Received: from mail.gmx.net ([213.165.64.20]:55900 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751250AbZJBSWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 14:22:37 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+FkGd02miFSIR8bdtApuy8fkJBiGxjdIXxIzeEQo
	l86cPTN4JOyKVi
Subject: Re: IO scheduler based IO controller V10
From: Mike Galbraith <efault@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       riel@redhat.com
In-Reply-To: <20091002180437.GL31616@kernel.dk>
References: <20091002092839.GA26962@kernel.dk>
	 <alpine.LFD.2.01.0910020715160.6996@localhost.localdomain>
	 <20091002145610.GD31616@kernel.dk>
	 <alpine.LFD.2.01.0910020811490.6996@localhost.localdomain>
	 <20091002171129.GG31616@kernel.dk> <20091002172046.GA2376@elte.hu>
	 <20091002172554.GJ31616@kernel.dk> <20091002172842.GA4884@elte.hu>
	 <20091002173732.GK31616@kernel.dk> <20091002175629.GA14860@elte.hu>
	 <20091002180437.GL31616@kernel.dk>
Content-Type: text/plain
Date: Fri, 02 Oct 2009 20:22:34 +0200
Message-Id: <1254507754.8667.15.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-02 at 20:04 +0200, Jens Axboe wrote:

> I'm not too crazy about it either. How about just using 'desktop' since
> this is obviously what we are really targetting? 'latency' isn't fully
> descriptive either, since it may not necessarily provide the best single
> IO latency (noop would).

Grin. "Perfect is the enemy of good" :)
                                                  Avg
     16.24   175.82   154.38   228.97   147.16  144.5     noop
     43.23    57.39    96.13   148.25   180.09  105.0     deadline


