Return-Path: <linux-kernel-owner+w=401wt.eu-S1758383AbXKTXBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383AbXKTXBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:01:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbXKTXBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:01:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34689 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbXKTXBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:01:36 -0500
Date: Wed, 21 Nov 2007 00:01:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: 2.6.24-rc3: find complains about /proc/net
Message-ID: <20071120230106.GD24380@elte.hu>
References: <20071119191000.GA1560@elf.ucw.cz> <200711192304.25087.rjw@sisk.pl> <4743026B.2020907@openvz.org> <m11wakshyz.fsf@ebiederm.dsl.xmission.com> <20071120215914.GE24156@elte.hu> <m1ve7wr28z.fsf@ebiederm.dsl.xmission.com> <20071120223559.GA6655@elte.hu> <20071120225457.B6E2D26F8BE@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071120225457.B6E2D26F8BE@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> When did /proc/self get changed to follow tgid instead of pid?  glibc 
> uses /proc/self to refer to various things that are usually shared 
> anyway (fd, maps, cwd, exe), but I think the expectation has always 
> been that this refers to the same calling thread, not the group 
> leader.  e.g., if one thread has changed uids so it no longer has 
> access to the group leader's /proc/PID/fd, suddenly it using 
> /proc/self/fd starts failing.

i guess it was a v2.6.24 change, hence a regression that needs to be 
fixed?

	Ingo
