Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbYDMUfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbYDMUfz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 16:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbYDMUfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 16:35:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48520
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752637AbYDMUfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 16:35:45 -0400
Date: Sun, 13 Apr 2008 13:35:46 -0700 (PDT)
Message-Id: <20080413.133546.43018013.davem@davemloft.net>
To: johnpol@2ka.mipt.ru
Cc: akpm@linux-foundation.org, w@1wt.eu, rjw@sisk.pl, tilman@imap.cc,
       Valdis.Kletnieks@vt.edu, lkml@rtr.ca, jesper.juhl@gmail.com,
       yoshfuji@linux-ipv6.org, jeff@garzik.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Reporting bugs and bisection
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080413202118.GA29658@2ka.mipt.ru>
References: <20080413184730.GD8474@1wt.eu>
	<20080413121831.d89dd424.akpm@linux-foundation.org>
	<20080413202118.GA29658@2ka.mipt.ru>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Date: Mon, 14 Apr 2008 00:21:18 +0400

> If the same would be done on developers machine and huge patches would
> be sent to jump between changesets, that would be a real 'work closely
> with the reporter working out why the reporter's failure was occurring'?

In fact, this is what Andrew's so-called "back and forth with the bug
reporter" used to mainly consist of.  Asking the user to try this patch or
that patch, which most of the time were reverts of suspect changes.

Which, surprise surprise, means we were spending lots of time
bisecting things by hand.

We're able to automate this now and it's not a bad thing.
