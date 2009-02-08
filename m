Return-Path: <linux-kernel-owner+w=401wt.eu-S1755089AbZBHVzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbZBHVzE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 16:55:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754596AbZBHVtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:49:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39647 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591AbZBHVs6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:48:58 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrea Righi" <righi.andrea@gmail.com>,
       "Andrey Borzenkov" <arvidjaar@mail.ru>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
In-Reply-To: <AIghyjFgMFP.A.uZD._10jJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sWhNs83kKPE.A.bKG.120jJB@chimera>
Subject: [Bug #12606] fb_mmap: circular locking dependency on hibernation
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  8 Feb 2009 20:21:43 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12606
Subject		: fb_mmap: circular locking dependency on hibernation
Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
Date		: 2009-01-27 18:37 (13 days old)
References	: http://marc.info/?l=linux-kernel&m=123308162731408&w=4
Handled-By	: Andrea Righi <righi.andrea@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&m=123365581406194&w=2


