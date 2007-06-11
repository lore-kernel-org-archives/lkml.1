Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbXFKOm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbXFKOm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 10:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbXFKOmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 10:42:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38716 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343AbXFKOmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 10:42:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: 2.6.22-rc4-mm2: Resume from RAM on HPC nx6325 broken
Date: Mon, 11 Jun 2007 16:48:59 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Lee Trager <lt73@cs.drexel.edu>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706111649.00578.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's the result of the search for the second patch that breaks resuming
from RAM on HPC nx6325 (x86_64):

ide-ide-hpa-detect-from-resume.patch

The symptom is that after the resume there's no backlight and the screen
apparently doesn't work, 100% of the time, although apart from this the system
seems to be functional.

The box doesn't even have an IDE HDD, but the DVD is handled by the atiixp
driver.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
