Return-Path: <linux-kernel-owner+w=401wt.eu-S1758885AbYAYO6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885AbYAYO6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 09:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758116AbYAYO6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 09:58:03 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:60814 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758080AbYAYO6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 09:58:00 -0500
Date: Fri, 25 Jan 2008 09:58:00 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pavel Machek <pavel@ucw.cz>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Buesch <mb@bu3sch.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       <bcm43xx-dev@lists.berlios.de>,
       Alessandro Rubini <rubini@vision.unipv.it>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH -mm 5/5] b43: Avoid unregistering device objects during
 suspend
In-Reply-To: <20080125074746.GC4134@ucw.cz>
Message-ID: <Pine.LNX.4.44L0.0801250955210.4190-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2008, Pavel Machek wrote:

> Maybe we should have global suspend_in_progress (or maybe system_state
> == suspending?) and automatically switch to schedule_removal() while
> it is set?

:-)  There was a time a couple of years ago when you objected violently 
to the mere suggestion of such a global variable!

It's not a bad idea IMO.  But if it does get implemented, a global
function would be better than a global variable.  It would provide
more encapsulation.

Alan Stern

