Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbZLSXxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbZLSXxG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 18:53:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbZLSXxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 18:53:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36137 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503AbZLSXxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 18:53:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Sun, 20 Dec 2009 00:53:45 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912200040.18944.rjw@sisk.pl> <alpine.LFD.2.00.0912191542570.3712@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912191542570.3712@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912200053.45988.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 December 2009, Linus Torvalds wrote:
> 
> On Sun, 20 Dec 2009, Rafael J. Wysocki wrote:
> > 
> > OK, so this means we can just forget about suspending/resuming i8042
> > asynchronously, which is a pity, because that gave us some real suspend
> > speedup on my test systems.
> 
> No. What it means is that you shouldn't try to come up with these idiotic 
> scenarios just trying to make trouble for yourself,

I haven't.  I've just asked Dmitry for his opinion and got it.  The fact that
you don't like it doesn't mean it's actually "idiotic".

> and using it as an excuse for crap.

I'm not sure what you mean exactly, but whatever.

> I suggest you try to treat the i8042 controller async, and see if it is 
> problematic.

I already have and I don't see problems with it, but quite obviously I can't
test all possible configurations out there.

> If it isn't, don't do that then. But we actually have no real 
> reason to believe that it would be problematic, at least on a PC where the 
> actual logic is on the SB (presumably behind the LPC controller).
> 
> Why would it be?

The embedded controller may depend on it.
 
Rafael
