Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbYKIUkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbYKIUkn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 15:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059AbYKIUke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 15:40:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755747AbYKIUkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 15:40:33 -0500
Date: Sun, 9 Nov 2008 12:39:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Bootup time regression from 2.6.27 to 2.6.28-rc3+
In-Reply-To: <20081109122835.10f410fa@infradead.org>
Message-ID: <alpine.LFD.2.00.0811091237110.3468@nehalem.linux-foundation.org>
References: <20081104173300.GF6134@ics.muni.cz> <20081109105159.GA5867@joi> <20081109113304.GE4353@ics.muni.cz> <200811091424.10943.rjw@sisk.pl> <20081109200918.GA4361@ics.muni.cz> <20081109122835.10f410fa@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 9 Nov 2008, Arjan van de Ven wrote:
> 
> for me, the plan is that we need to get Thomas' fixes tested by someone
> who can reproduce this very reliably. If they fix it, great.
> If they don't, time is running out and we need to remove the feature
> for 2.6.28 (that is 1 line of change), realizing that this just papers
> over stuff and isn't a real fix, and get back to it for 2.6.29.

I'd like to see the one-liner fix, even if it turns out to just be a 
workaround that hides the issue and makes us go back to 2.6.27 behaviour. 
I'm about to release -rc4 today, we should be aggressive about 
regressions.

If somebody can test the "real fix" independently, that's obviously fine, 
but it's not an excuse for keeping a pending regression. If people end up 
being 100% sure they found the bug later, we can then re-enable it, but 
again - that has zero bearing on the fact that we should get rid of the 
regression asap.

			Linus
