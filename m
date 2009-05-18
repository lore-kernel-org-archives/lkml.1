Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbZERTCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbZERTCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 15:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbZERTCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 15:02:47 -0400
Received: from vena.lwn.net ([206.168.112.25]:36316 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbZERTCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 15:02:46 -0400
Date: Mon, 18 May 2009 13:02:46 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.30-rc kills my box hard - and lockdep chains
Message-ID: <20090518130246.4a68800c@bike.lwn.net>
In-Reply-To: <20090516161419.62c45c2b.akpm@linux-foundation.org>
References: <20090514094951.36fd7333@bike.lwn.net>
	<20090516161419.62c45c2b.akpm@linux-foundation.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 May 2009 16:14:19 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> So the lockup isn't due to lockdep.

It is not; I turned on lockdep in an attempt to track down the problem.

> Did you try all the usual sysrq-P, nmi-watchdog stuff?

Yep.  But I've never been able to get a response out of the system when
this kind of thing happens.

> Is netconsole enabled, to see if it squawked as it died?

That I do not have; worth trying.

One interesting thing of note: I was reliably getting about one lockup
per day.  Until I turned on lockdep.  It's been 4-5 days now with
no repeats of the problem.  I have no idea if it's coincidental or if
there is a real correlation there.

jon
