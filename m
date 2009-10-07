Return-Path: <linux-kernel-owner+w=401wt.eu-S1760023AbZJGURl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023AbZJGURl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 16:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760013AbZJGURk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 16:17:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37606 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959AbZJGURj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 16:17:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jan Scholz <scholz@fias.uni-frankfurt.de>
Subject: Re: [regression, bisected] adb trackpad disappears after suspend to ram
Date: Wed, 7 Oct 2009 22:18:22 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-rjw; KDE/4.3.1; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Johannes Berg <johannes@sipsolutions.net>
References: <878wkl6vce.fsf@scholz.fias.uni-frankfurt.de> <1253741332.7103.324.camel@pasglop> <878wfnt9je.fsf@scholz.fias.uni-frankfurt.de>
In-Reply-To: <878wfnt9je.fsf@scholz.fias.uni-frankfurt.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910072218.22357.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 October 2009, Jan Scholz wrote:
> Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:
> 
> >> Alternatively, you could introduce a new flag IRQF_NOSUSPEND and use that
> >> instead of IRQF_TIMER.  That would be cleaner than using IRQF_TIMER for
> >> non-timer interrupts IMHO.
> >
> > I totally agree. The current patch is still good for stable though.
> >
> > I'll send it to Greg after I've upstreamed it, we can introduce IRQF_NOSUSPEND
> > in a second patch.
> 
> How's upstreaming going? I can neither find the patch in Linus branch,
> nor in linux-next. Could it be that it got lost?

More likely Ben didn't have the time to work on it.

Best,
Rafael
