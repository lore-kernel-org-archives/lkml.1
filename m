Return-Path: <linux-kernel-owner+w=401wt.eu-S1753077AbZKOOOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbZKOOOs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 09:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbZKOOOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 09:14:47 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:40144 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbZKOOOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 09:14:47 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: Joe Perches <joe@perches.com>, Am??rico Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sysctl.c: Change a .proc_handler = proc_dointvec to &proc_dointvec,
References: <1258249925.16857.198.camel@Joe-Laptop.home>
	<20091115065958.GA2459@hack> <20091115081126.GD15432@elte.hu>
	<1258273714.21668.13.camel@Joe-Laptop.home>
	<20091115083951.GA27393@elte.hu> <m1hbswm7dk.fsf@fess.ebiederm.org>
	<20091115103307.GB24931@elte.hu> <m11vk0m0np.fsf@fess.ebiederm.org>
	<20091115135705.GA9329@elte.hu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 15 Nov 2009 06:14:45 -0800
In-Reply-To: <20091115135705.GA9329@elte.hu> (Ingo Molnar's message of "Sun\, 15 Nov 2009 14\:57\:05 +0100")
Message-ID: <m1bpj3lvsa.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> The preferred flow is for you to just work against Linus's latest tree - 
> and everyone will deal with the (mostly trivial) conflicts when they 
> happen. Linus prefers to resolve conflicts himself when he pulls, 
> because people mixing their trees (such as you basing on net-next for 
> example) leads to various dependency problems.

Sounds right.

I'm still getting up the courage to conflict.  I was wondering if I
could cherry pick a patch or two to avoid those.

Right now in the net tree there is one new sysctl and one bug fix to a
sysctl strategy routine I intend to delete.

The core or my changes are in.  This is just purging dead code.

It looks like those two changes may actually be single patches so I
could cherry pick them and in theory have no conflicts.

At the very least I'm going to wait for one more build of net-next with
everything but my network stack changes before I add those.

So far the conflicts are pretty minimal so I guess it doesn't matter
much.

Eric
