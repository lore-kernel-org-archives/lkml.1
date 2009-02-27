Return-Path: <linux-kernel-owner+w=401wt.eu-S1759728AbZB0Uqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728AbZB0Uqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 15:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755819AbZB0Uqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 15:46:34 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37097 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616AbZB0Uqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 15:46:34 -0500
Date: Fri, 27 Feb 2009 21:46:15 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Oliver Neukum <oliver@neukum.org>, Alan Stern <stern@rowland.harvard.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Arve Hj?nnev?g <arve@android.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090227204615.GC1387@ucw.cz>
References: <200902191356.53584.rjw@sisk.pl> <Pine.LNX.4.44L0.0902190956570.3012-100000@iolanthe.rowland.org> <20090222140311.GF1387@ucw.cz> <200902231504.27879.oliver@neukum.org> <20090227101818.GH4582@elf.ucw.cz> <49A81E59.6010105@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A81E59.6010105@nortel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-02-27 11:09:45, Chris Friesen wrote:
> Pavel Machek wrote:
>> On Mon 2009-02-23 15:04:22, Oliver Neukum wrote:
>
>>> We can just as well have a class of tasks less important than power
>>> saving. They'd just run when power saving is not active for some other
>>> reason. Just like other such schemes we end up with the problem
>>> of priority inversion with locking.
>>
>> Ok, I guess this could be interesting in some cases... maybe. What are
>> real examples of such tasks?
>
> Some people might put casual system monitoring tools into this  
> category--top, xload, gkrellm, xclock, etc.

I guess system monitoring should stop itself when screen is
blanked... no need to compute list of processes if user can't see the
output.

But I see that may be slightly hard for command-line tool like
top. .... but it still seems like right solution. Why waste power/cycles
displaying xclock at tty9 when user is looking at tty10?

> It'd be nice if the animated banner ad in my web browser could be  
> treated this way. :)

Well, my web browser already has an option 'animate once'. No need to
waste power with that at all :-).
							Pavel 
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
