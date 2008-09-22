Return-Path: <linux-kernel-owner+w=401wt.eu-S1753607AbYIVPcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbYIVPcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 11:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbYIVPcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 11:32:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33830 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbYIVPcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 11:32:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Regression] Commit 2344abbcbdb82140050e8be29d3d55e4f6fe860b breaks resume on nx6325
Date: Mon, 22 Sep 2008 17:37:31 +0200
User-Agent: KMail/1.9.9
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>
References: <200809210124.30547.rjw@sisk.pl> <200809220036.52831.rjw@sisk.pl> <20080922084103.GF6601@elte.hu>
In-Reply-To: <20080922084103.GF6601@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809221737.32117.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 22 of September 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > So, it looks like RCU is broken and I have no idea how to debug it 
> > further.
> > 
> > Please advise.
> 
> i think RCU is not broken, RCU just happens to be the first entity 
> affected by C1E-enter magically killing the (previously working) lapic 
> timer clockevents device.

Well, I should have said "RCU breaks as a result of the underlying issue". :-)

> We are working on a fix. 

Thanks!

Rafael
