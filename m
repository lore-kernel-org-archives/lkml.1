Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbZASUYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbZASUYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 15:24:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbZASUYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 15:24:34 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39490 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbZASUYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 15:24:33 -0500
Date: Mon, 19 Jan 2009 21:24:24 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>, teheo@novell.com,
       trenn@suse.de
Subject: 2.6.29-rc2: thinkpad dock -- cdrom vs. s2ram
Message-ID: <20090119202423.GA7070@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

In 2.6.29 (and probably earlier) kernels, booting in docking station
results in undocked s2ram failing.

Problem seems to be that hda (cdrom in dock) is not deregistered
during undock, and that hda driver loops spitting error messages at
'too-fast-to-read' rate when suspend with missing hda is attempted.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
