Return-Path: <linux-kernel-owner+w=401wt.eu-S1760036AbYGAPOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036AbYGAPOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 11:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbYGAPOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 11:14:22 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:42533 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833AbYGAPOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 11:14:21 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-9.tower-164.messagelabs.com!1214925259!20868972!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Tue, 1 Jul 2008 17:14:15 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Andrew Morton <akpm@osdl.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: A minimally power-aware driver treats all messages as SUSPEND?
Message-ID: <20080701151415.GA17688@digi.com>
References: <20080701072911.GA6564@digi.com> <200807011617.55501.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200807011617.55501.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 01 Jul 2008 15:14:16.0714 (UTC) FILETIME=[20CB86A0:01C8DB8D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rafael,

Rafael J. Wysocki wrote:
> On Tuesday, 1 of July 2008, Uwe Kleine-König wrote:
> > include/linux/pm.h claims:
> >
> >       A minimally power-aware driver treats all messages as SUSPEND
> >       [...].
> >
> > This was introduced in commit 82bb67f2 by David Brownell.  At this time
> > PM_EVENT_HIBERNATE didn't exist.  This was added in 3a2d5b70 by Rafael
> > J. Wysocki without updating the above sentence.  I think a minimally
> > power-aware driver should treat all messages as HIBERNATE, shouldn't it?
> 
> No, I don't think so.  In the majority of cases, SUSPEND is equivalent to the
> combination of FREEZE and HIBERNATE.
I didn't get that.  I thought SUSPEND is suspend-to-ram and HIBERNATE is
suspend-to-disk, so HIBERNATE is the "deeper sleep".
With that I might have to do less on SUSPEND because some state might be
preserved after the machine comes up again.

> Still, this is going to change anyway with the introduction of the new
> suspend/hibernation callbacks that are scheduled for 2.6.27.
in next?

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
