Return-Path: <linux-kernel-owner+w=401wt.eu-S932226AbXIFFYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226AbXIFFYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 01:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbXIFFYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 01:24:37 -0400
Received: from gherkin.frus.com ([192.158.254.49]:33526 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbXIFFYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 01:24:36 -0400
Subject: [BUG] 2.6.23-rc5 panics
To: linux-kernel@vger.kernel.org
Date: Thu, 6 Sep 2007 00:24:34 -0500 (CDT)
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070906052434.B7420DBA2@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This may be the most worthless bug report ever filed, but maybe someone
else is seeing this that can shed some light on the matter.  Everything
was rock-solid with -rc3, but I've had two panics with -rc5 in as many
days.  The first occurred within five minutes of booting.  The second
was after nearly 48 hours of uptime.  Nothing is getting written to
syslog, and the second panic happened while X11 was active, so I didn't
even get so much as a stack dump on the console -- just the flashing
keyboard leds that signaled entry into "brick emulation" mode :-(.

System is a k6-III/450 w/SCSI drives (AIC7XXX) and a Netgear FA311 NIC.
At this point, I have no idea what's triggering the panics.  Doesn't
seem related to load that I can tell...

-- 
------------------------------------------------------------------------
Bob Tracy          |  "They couldn't hit an elephant at this dist- "
rct@frus.com       |   - Last words of Union General John Sedgwick,
                   |  Battle of Spotsylvania Court House, U.S. Civil War
------------------------------------------------------------------------
