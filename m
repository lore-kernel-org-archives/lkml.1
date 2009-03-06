Return-Path: <linux-kernel-owner+w=401wt.eu-S1757089AbZCFSoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbZCFSoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 13:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbZCFSoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 13:44:09 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50392 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbZCFSoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 13:44:08 -0500
Date: Fri, 6 Mar 2009 19:43:56 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] Add virtual "idle" device
Message-ID: <20090306184356.GA1311@ucw.cz>
References: <1236033772-20329-2-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236033772-20329-2-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-03-02 23:42:52, Marcin Slusarz wrote:
> This virtual device can be used to tell user space about periods of time
> when user didn't "touch" input devices (keyboards, mice, touchpads, joysticks,
> etc). For now it supports only keyboard events.
> 
> Notification is done through simple select/poll + ioctl interface.
> 
> It can be used to implement screen savers, automatic suspend,
> autoaway/autodisconnect (e.g. in instant messangers) without
> any help from X server and its overhead (context switches).

I don't think this is good interface; what if you have more than one
seat? And without mouse handling it is useless anyway, so....

								Pavel
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
