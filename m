Return-Path: <linux-kernel-owner+w=401wt.eu-S1762847AbXE1RwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762847AbXE1RwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 13:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758029AbXE1RwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 13:52:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60671 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758002AbXE1RwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 13:52:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [2.6.21.1] resume doesn't run suspended kernel?
Date: Mon, 28 May 2007 19:57:38 +0200
User-Agent: KMail/1.9.5
Cc: Bill Davidsen <davidsen@tmr.com>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
References: <4658B7DD.3060309@tmr.com> <465AD746.7090008@tmr.com> <20070528132625.GQ18807@elf.ucw.cz>
In-Reply-To: <20070528132625.GQ18807@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705281957.38954.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 28 May 2007 15:26, Pavel Machek wrote:
> Hi!
> 
> > >That's clear, I'll have to use xen or kvm or similar which restores 
> > >the system as suspended. Thanks for the clarification of the limitations.
> > >
> > Sorry, I wrote that late at night and quickly. I should have said 
> > "design decision" rather than "limitation," For systems which don't do 
> > multiple kernels it's not an issue.
> > 
> > I certainly would not have made the same decision, but I didn't write 
> > the code. It seems more robust to save everything than to try to 
> > identify what has and hasn't changed in a modular kernel.
> 
> We rely on atomic copy routine not moving inside the kernel. Yes, it
> would be possible to copy it to "known good" address and gain ability
> to resume different kernels. Actually it should not be _that_ hard.

Yup.  Don't we do something like this for the (ACPI-based) suspend to RAM
already?

Greetings,
Rafael
