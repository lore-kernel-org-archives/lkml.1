Return-Path: <linux-kernel-owner+w=401wt.eu-S933843AbXDBRJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933843AbXDBRJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 13:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933846AbXDBRJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 13:09:46 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36804 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933843AbXDBRJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 13:09:45 -0400
Date: Mon, 2 Apr 2007 10:09:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
cc: David Brownell <david-b@pacbell.net>,
       Maxim Levitsky <maximlevitsky@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: [linux-pm] [PATCH v2] Add suspend/resume for HPET
In-Reply-To: <Pine.LNX.4.44L0.0704021000450.1743-100000@netrider.rowland.org>
Message-ID: <Pine.LNX.4.64.0704021007440.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.44L0.0704021000450.1743-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Apr 2007, Alan Stern wrote:
> 
> Would you mind retracting this patch?  It will interfere with some work
> I've been doing in USB, work that relies on exactly the sort of multiple 
> power dependency you mention.

I agree. We should just make the damn timers be added at the right point. 
We can for example *add* the devices early, even if we then actually start 
using them at some later date.

			Linus
