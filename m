Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab0AOShF (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 13:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173Ab0AOShD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 13:37:03 -0500
Received: from fom01.emnet.dk ([89.249.14.84]:53123 "EHLO fom01.emnet.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549Ab0AOShB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 13:37:01 -0500
X-AuditID: 59f90e54-b7bd7ae000001243-d0-4b50b5cb38f6
Subject: Re: option driver freezing entire system
From: Kasper Sandberg <lkml@metanurb.dk>
To: Oliver Neukum <oliver@neukum.org>
Cc: smurf@smurf.noris.de, LKML Mailinglist <linux-kernel@vger.kernel.org>
In-Reply-To: <201001151855.46217.oliver@neukum.org>
References: <1263577116.27788.131.camel@localhost>
	 <201001151855.46217.oliver@neukum.org>
Content-Type: text/plain
Date: Fri, 15 Jan 2010 19:36:55 +0100
Message-Id: <1263580615.27788.134.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-15 at 18:55 +0100, Oliver Neukum wrote:
> Am Freitag, 15. Januar 2010 18:38:36 schrieb Kasper Sandberg:
> > Hello..
> > 
> > Im having some issues with some huawei e1752 modems, the computer
> > sometimes completely freezes, and i suspect its due to the option
> > driver, as it doesnt happen if i dont modeswitch them to appear as
> > option modem.
> > 
> > Do you have any idea what might cause this? i looked all over the system
> > logs and theres nothing to help at all, but i have seen this spanning
> > from .26 to .32, on multiple computers, and i just dont know what to do
> > to fix it.
> 
> Please recompile your kernel with lockdep. This should improve
> debugging.

It is a debian unstable .32 kernel i run now, and grepping for lockdep
reveals:
CONFIG_LOCKDEP_SUPPORT=y
only, is there anything more i should have? (never used lockdep before)

> 
> 	Regards
> 			Oliver

