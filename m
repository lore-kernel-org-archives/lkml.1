Return-Path: <linux-kernel-owner+w=401wt.eu-S1758555AbYAYKPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbYAYKPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 05:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbYAYKPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 05:15:30 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:34396 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbYAYKP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 05:15:29 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH -mm 5/5] b43: Avoid unregistering device objects during suspend
Date: Fri, 25 Jan 2008 11:13:30 +0100
User-Agent: KMail/1.9.6
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, bcm43xx-dev@lists.berlios.de,
       Alessandro Rubini <rubini@vision.unipv.it>,
       Richard Purdie <rpurdie@rpsys.net>
References: <200801250127.21966.rjw@sisk.pl> <200801250137.34275.rjw@sisk.pl> <20080125074746.GC4134@ucw.cz>
In-Reply-To: <20080125074746.GC4134@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801251113.31325.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 January 2008 08:47:46 Pavel Machek wrote:
> On Fri 2008-01-25 01:37:33, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Modify the b43 driver to avoid deadlocking suspend and resume,
> > which happens as a result of attempting to unregister device objects
> > locked by the PM core during suspend/resume cycles.  Also, make it
> > use a suspend-safe method of unregistering device object in the
> > resume error path.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > Acked-by: Michael Buesch <mb@bu3sch.de>
> 
> Maybe we should have global suspend_in_progress (or maybe system_state
> == suspending?) and automatically switch to schedule_removal() while
> it is set?
> 

That would be great, from my perspective :)

-- 
Greetings Michael.
