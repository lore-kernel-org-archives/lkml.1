Return-Path: <linux-kernel-owner+w=401wt.eu-S1756178AbZKQTDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbZKQTDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 14:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756167AbZKQTDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 14:03:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756165AbZKQTDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 14:03:48 -0500
Date: Tue, 17 Nov 2009 11:02:46 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] strcmp: fix overflow error
In-Reply-To: <20091117185539.GA23385@pengutronix.de>
Message-ID: <alpine.LFD.2.01.0911171102210.9384@localhost.localdomain>
References: <1258476700-21323-1-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LFD.2.01.0911170922190.9384@localhost.localdomain> <20091117185539.GA23385@pengutronix.de>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Nov 2009, Uwe Kleine-König wrote:
>
> (BTW, this was already broken in 2.4.0, so I was unable to find out who
> is the moron :-)

Yeah, I looked at the history too. It's so old that it might well be me.

			Linus
