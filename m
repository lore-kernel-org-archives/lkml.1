Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbZLSXqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbZLSXqO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 18:46:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754270AbZLSXqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 18:46:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754072AbZLSXqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 18:46:12 -0500
Date: Sat, 19 Dec 2009 15:46:04 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <200912200040.18944.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0912191542570.3712@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912200010.19899.rjw@sisk.pl> <alpine.LFD.2.00.0912191521180.3712@localhost.localdomain> <200912200040.18944.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 20 Dec 2009, Rafael J. Wysocki wrote:
> 
> OK, so this means we can just forget about suspending/resuming i8042
> asynchronously, which is a pity, because that gave us some real suspend
> speedup on my test systems.

No. What it means is that you shouldn't try to come up with these idiotic 
scenarios just trying to make trouble for yourself, and using it as an 
excuse for crap.

I suggest you try to treat the i8042 controller async, and see if it is 
problematic. If it isn't, don't do that then. But we actually have no real 
reason to believe that it would be problematic, at least on a PC where the 
actual logic is on the SB (presumably behind the LPC controller).

Why would it be?

The fact that PnP and ACPI enumerates those devices has exactly _what_ to 
do with anything?

		Linus
