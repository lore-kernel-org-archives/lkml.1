Return-Path: <linux-kernel-owner+w=401wt.eu-S1757093AbYKIUHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093AbYKIUHR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 15:07:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756832AbYKIT50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 14:57:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44514 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756576AbYKIT5V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 14:57:21 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       "Keith Packard" <keithp@keithp.com>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
In-Reply-To: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <wnN9HICUAgP.A.Z-E.Q4zFJB@chimera>
Subject: [Bug #11988] Eliminate recursive mutex in compat fb ioctl path
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Nov 2008 18:59:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11988
Subject		: Eliminate recursive mutex in compat fb ioctl path
Submitter	: Keith Packard <keithp@keithp.com>
Date		: 2008-11-03 7:06 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=122569604828448&w=4
Handled-By	: Keith Packard <keithp@keithp.com>
		  Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Patch		: http://marc.info/?l=linux-kernel&m=122569604828448&w=4
		  http://lkml.org/lkml/2008/10/31/162


