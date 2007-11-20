Return-Path: <linux-kernel-owner+w=401wt.eu-S1764946AbXKTXn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764946AbXKTXn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:43:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763793AbXKTXnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:43:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37221 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763560AbXKTXnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:43:40 -0500
Date: Wed, 21 Nov 2007 00:43:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Roland McGrath <roland@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: 2.6.24-rc3: find complains about /proc/net
Message-ID: <20071120234323.GE23667@elte.hu>
References: <20071119191000.GA1560@elf.ucw.cz> <200711192304.25087.rjw@sisk.pl> <4743026B.2020907@openvz.org> <m11wakshyz.fsf@ebiederm.dsl.xmission.com> <20071120215914.GE24156@elte.hu> <m1ve7wr28z.fsf@ebiederm.dsl.xmission.com> <20071120223559.GA6655@elte.hu> <20071120225457.B6E2D26F8BE@magilla.localdomain> <20071120230106.GD24380@elte.hu> <3d8471ca0711201506t6b2b88a0h9484f8a40a1f2e40@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d8471ca0711201506t6b2b88a0h9484f8a40a1f2e40@mail.gmail.com>
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


* Guillaume Chazarain <guichaz@yahoo.fr> wrote:

> On 11/21/07, Ingo Molnar <mingo@elte.hu> wrote:
> > i guess it was a v2.6.24 change, hence a regression that needs to be
> > fixed?
> 
> It seems to be
> 
> http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=commitdiff;h=01660410
> 
> So, linux 2.6.0-test6

grumble :-/ So i guess /proc/self-task it has to be.

	Ingo
