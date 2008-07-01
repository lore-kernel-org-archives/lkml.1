Return-Path: <linux-kernel-owner+w=401wt.eu-S1759331AbYGAOQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759331AbYGAOQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 10:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbYGAOQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 10:16:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58403 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbYGAOQH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 10:16:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Uwe =?iso-8859-1?q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
Subject: Re: A minimally power-aware driver treats all messages as SUSPEND?
Date: Tue, 1 Jul 2008 16:17:54 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@osdl.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
References: <20080701072911.GA6564@digi.com>
In-Reply-To: <20080701072911.GA6564@digi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807011617.55501.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 1 of July 2008, Uwe Kleine-König wrote:
> Hello,
> 
> include/linux/pm.h claims:
> 
> 	A minimally power-aware driver treats all messages as SUSPEND
> 	[...].
> 
> This was introduced in commit 82bb67f2 by David Brownell.  At this time
> PM_EVENT_HIBERNATE didn't exist.  This was added in 3a2d5b70 by Rafael
> J. Wysocki without updating the above sentence.  I think a minimally
> power-aware driver should treat all messages as HIBERNATE, shouldn't it?

No, I don't think so.  In the majority of cases, SUSPEND is equivalent to the
combination of FREEZE and HIBERNATE.

Still, this is going to change anyway with the introduction of the new
suspend/hibernation callbacks that are scheduled for 2.6.27.

Thanks,
Rafael
