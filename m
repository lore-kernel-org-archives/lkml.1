Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbZJRTTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbZJRTTx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 15:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755119AbZJRTTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 15:19:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38994 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbZJRTTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 15:19:52 -0400
Date: Sun, 18 Oct 2009 21:19:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Stanislav Brabec <utx@penguin.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux@arm.linux.org.uk,
       linux-kernel@vger.kernel.org, gregkh@suse.de, alan@lxorguk.ukuu.org.uk,
       s.hauer@pengutronix.de, saxena@laptop.org
Subject: Re: [PATCH] serial-core: resume serial hardware with
 no_console_suspend
Message-ID: <20091018191948.GA8800@elf.ucw.cz>
References: <1253021938.6597.16.camel@hammer.suse.cz>
 <20090924170503.37cbe4ed.akpm@linux-foundation.org>
 <20090925073617.GA5856@n2100.arm.linux.org.uk>
 <1253872547.13257.18.camel@hammer.suse.cz>
 <20091005162741.599a1be9.akpm@linux-foundation.org>
 <1255878358.4581.29.camel@utx.utx.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255878358.4581.29.camel@utx.utx.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> ???It can be fixed either by changing suspend/resume order to wake serial
> console early in the order, or by a non-standard hook in the early
> resume process.

Well, moving serial to sysdev state is probably bad idea, but having
non-standard hook that is easy to patch in would be very cool.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
