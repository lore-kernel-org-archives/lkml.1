Return-Path: <linux-kernel-owner+w=401wt.eu-S933926AbZLMBlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933926AbZLMBlz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933849AbZLMBly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:41:54 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36633 "HELO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933836AbZLMBlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:41:52 -0500
Date: Sat, 12 Dec 2009 20:31:17 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ferenc Wagner <wferi@niif.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] intermittent suspend problem again
Message-ID: <20091212192727.GC1308@ucw.cz>
References: <87fx93pwv2.fsf@tac.ki.iif.hu> <200912011328.15551.rjw@sisk.pl> <877ht68u4h.fsf@tac.ki.iif.hu> <200912012232.50951.rjw@sisk.pl> <87638qw2zy.fsf@tac.ki.iif.hu> <87skbtve5w.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87skbtve5w.fsf@tac.ki.iif.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Btw. s2disk has a strange effect of simulating enters during suspend.
> > [...]
> > Can you also see this?
> 
> It can't be seen from the "sleep 1; s2disk" command, so it's probably an
> artifact from X, when s2disk starts before Enter is released.

Yes, I see that, too, and believe it is X artifact.

(X keyboard handling is really broken: it does its own
autorepeat. That does not really work when big latencies are around.)
								Pavel 
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
