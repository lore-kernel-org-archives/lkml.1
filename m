Return-Path: <linux-kernel-owner+w=401wt.eu-S1753970AbZJVHC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbZJVHC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 03:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbZJVHC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 03:02:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47062 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbZJVHC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 03:02:26 -0400
Date: Thu, 22 Oct 2009 09:02:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       rjw@sisk.pl, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: question on the freezer and line disciplines
Message-ID: <20091022070224.GD2211@elf.ucw.cz>
References: <200910211529.22206.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910211529.22206.oliver@neukum.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-10-21 15:29:21, Oliver Neukum wrote:
> Hi,
> 
> to which extent does the freezer protect serial drivers
> against unthrottle during suspension and throttle during
> resumption?

Freezer stops all of userspace and some of kernel threads. If
(un)throttle is hardware event, it probably does not prevent it.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
