Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400AbZLAQtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbZLAQtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753785AbZLAQtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:49:35 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:42813 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbZLAQte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:49:34 -0500
Message-ID: <4B154920.40203@gmail.com>
Date: Tue, 01 Dec 2009 17:49:36 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: William Allen Simpson <william.allen.simpson@gmail.com>
CC: Joe Perches <joe@perches.com>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: warning: massive change to conditional coding style in net?
References: <4B13A025.7000103@gmail.com> <1259603798.29779.293.camel@Joe-Laptop.home> <4B153F9B.7050502@gmail.com>
In-Reply-To: <4B153F9B.7050502@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 01 Dec 2009 17:49:37 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

William Allen Simpson a écrit :
> Joe Perches wrote:
>> If it makes getting tcp cookies accepted difficult,
>> a reversion is simple.  That style isn't as important.
>>
> Then why make an *un*important (yet sweeping) change?

Because this is time :

We usually makes cleanup patches just before the release
of a new linux kernel, to minimize effects on developer trees.

We know linux-2.6.32 is about to be released by Linus,
and all major 2.6.33 patches are already queued in net-next-2.6
to be pushed to Linus as soon as the window opens.

This is the perfect time for cleanups. Doing cleanups is a good
way to learn linux code, before doing more complex things.

If you take a look at queued patches in net-next-2.6, maybe less
than 5 % are cleanups.

But this rule can be changed, if your patches are ready for inclusion,
David might revert the jumbo cleanup to ease your job. Just ask.

