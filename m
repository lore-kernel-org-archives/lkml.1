Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbYK0Lm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbYK0Lm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 06:42:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYK0Lms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 06:42:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58702
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752358AbYK0Lms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 06:42:48 -0500
Date: Thu, 27 Nov 2008 03:42:47 -0800 (PST)
Message-Id: <20081127.034247.72331360.davem@davemloft.net>
To: eranian@gmail.com, eranian@googlemail.com
Cc: andi@firstfloor.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       sfr@canb.auug.org.au
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
From: David Miller <davem@davemloft.net>
In-Reply-To: <7c86c4470811270335p2dbd61ebpe2c584e32d8b2292@mail.gmail.com>
References: <7c86c4470811270209q18d4e83aq8901837159838cc4@mail.gmail.com>
	<20081127113115.GH6703@one.firstfloor.org>
	<7c86c4470811270335p2dbd61ebpe2c584e32d8b2292@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "stephane eranian" <eranian@googlemail.com>
Date: Thu, 27 Nov 2008 12:35:54 +0100

> I am still wondering how Oprofile handles the case where multiple
> processes or threads access the same file descriptor.

There's only one profiling buffer active on a given cpu,
so it's pure per-cpu value insertion.

In any event I think that NMI profiling is a must, especially
for the kernel.  You get total unusable crap otherwise.  I
just learned this the hard way having gotten an NMI'ish scheme
working on sparc64 just the other day.
