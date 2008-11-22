Return-Path: <linux-kernel-owner+w=401wt.eu-S1758268AbYKVWbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268AbYKVWbh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 17:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757528AbYKVW31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 17:29:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37705 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757460AbYKVW3Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 17:29:24 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Denys Vlasenko" <vda.linux@googlemail.com>,
       "Helge Deller" <deller@gmx.de>, "Jeroen Roovers" <jer@gentoo.org>,
       "Jiri Kosina" <jkosina@suse.cz>, "Jiri Slaby" <jirislaby@gmail.com>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
In-Reply-To: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vyitTh0pP2N.A.EdD.e8HKJB@chimera>
Subject: [Bug #11913] USB/INPUT: slab error in cache_alloc_debugcheck_after(): double free?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 22 Nov 2008 21:28:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11913
Subject		: USB/INPUT: slab error in cache_alloc_debugcheck_after(): double free?
Submitter	: Helge Deller <deller@gmx.de>
Date		: 2008-10-30 23:11 (24 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=cb8f488c33539f096580e202f5438a809195008f
References	: http://marc.info/?l=linux-kernel&m=122540833301394&w=4
Handled-By	: Jiri Kosina <jkosina@suse.cz>
		  Jiri Slaby <jirislaby@gmail.com>
		  Jiri Kosina <jkosina@suse.cz>
		  Jiri Slaby <jirislaby@gmail.com>
		  Denys Vlasenko <vda.linux@googlemail.com>


