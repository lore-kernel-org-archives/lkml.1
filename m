Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbYKIOHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbYKIOHp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 09:07:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbYKIOHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 09:07:35 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:32823 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754838AbYKIOHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 09:07:35 -0500
Date: Sun, 9 Nov 2008 15:07:26 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: CONFIG_NUMA breaks hibernation on x86-32 with PAE
Message-ID: <20081109140726.GB1786@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


...at least on 2.6.27 and 2.6.28-rc3. Resume gets to
acpi_hibernation_leave, then SLAB corruption is detected and machine
ends in series of oops.

Any ideas how to debug that?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
