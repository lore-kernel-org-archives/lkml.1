Return-Path: <linux-kernel-owner+w=401wt.eu-S1759858AbXKTXvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759858AbXKTXvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:51:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764002AbXKTXvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:51:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762367AbXKTXvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:51:17 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Ulrich Drepper <drepper@redhat.com>,
       Guillaume Chazarain <guichaz@yahoo.fr>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: Re: 2.6.24-rc3: find complains about /proc/net
In-Reply-To: Ingo Molnar's message of  Wednesday, 21 November 2007 00:45:05 +0100 <20071120234505.GF23667@elte.hu>
References: <4743026B.2020907@openvz.org>
	<m11wakshyz.fsf@ebiederm.dsl.xmission.com>
	<20071120215914.GE24156@elte.hu>
	<m1ve7wr28z.fsf@ebiederm.dsl.xmission.com>
	<20071120223559.GA6655@elte.hu>
	<20071120225457.B6E2D26F8BE@magilla.localdomain>
	<20071120230106.GD24380@elte.hu>
	<3d8471ca0711201506t6b2b88a0h9484f8a40a1f2e40@mail.gmail.com>
	<20071120232600.F1D2F26F8BE@magilla.localdomain>
	<47436E7F.2060901@redhat.com>
	<20071120234505.GF23667@elte.hu>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20071120235114.0B85226F8BE@magilla.localdomain>
Date: Tue, 20 Nov 2007 15:51:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> can you see any danger to providing a /proc/self_task/ link? (or can you 
> think of a better name/API/approach)

That is a poor name to choose given /proc/self/task exists as something
else (just try writing a sentence comparing them and then read it aloud).
Probably /proc/self/task/self is what makes the most sense structurally.
I don't know if it matters to whatever use you are concerned with to have
two more steps in the lookup.

Thanks,
Roland
