Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbYGAQnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbYGAQnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 12:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbYGAQnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 12:43:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813AbYGAQnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 12:43:39 -0400
Date: Tue, 1 Jul 2008 09:43:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
cc: Andrew Morton <akpm@linuxfoundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: A minimally power-aware driver treats all messages as SUSPEND?
In-Reply-To: <20080701072911.GA6564@digi.com>
Message-ID: <alpine.LFD.1.10.0807010942330.20870@hp.linux-foundation.org>
References: <20080701072911.GA6564@digi.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 Jul 2008, Uwe Kleine-König wrote:
> 
> This was introduced in commit 82bb67f2 by David Brownell.  At this time
> PM_EVENT_HIBERNATE didn't exist.  This was added in 3a2d5b70 by Rafael
> J. Wysocki without updating the above sentence.  I think a minimally
> power-aware driver should treat all messages as HIBERNATE, shouldn't it?

No.

A minimally power-aware driver should aim to work with STR.

HIBERNATE should be a secondary goal (if even that).

			Linus
