Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab0BHAu6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 19:50:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55599 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932266Ab0BHAqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 19:46:36 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>, "al" <al@dizzy.pdmi.ras.ru>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Christian Casteyde" <casteyde.christian@free.fr>,
       "Vegard Nossum" <vegard.nossum@gmail.com>
References: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera>
In-Reply-To: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <iuJeop2ribM.A.cZ.0Y1bLB@chimera>
Subject: [Bug #14998] Caught 32-bit read from uninitialized memory in acpi_system_read_event -- 2.6.31 regression
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon,  8 Feb 2010 01:28:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14998
Subject		: Caught 32-bit read from uninitialized memory in acpi_system_read_event -- 2.6.31 regression
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2010-01-06 21:40 (33 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/eca6f534e61919b28fb21aafbd1c2983deae75be


