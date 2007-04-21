Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869AbXDUVPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbXDUVPk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 17:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbXDUVPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 17:15:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54300 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbXDUVPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 17:15:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 0/2] Add suspend-related notifications for CPU hotplug
Date: Sat, 21 Apr 2007 23:16:38 +0200
User-Agent: KMail/1.9.5
Cc: Gautham R Shenoy <ego@in.ibm.com>, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200704212316.39381.rjw@sisk.pl>
X-Length: 1177
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry for the duplicates, I forgot to add the LKML to the CC list]

Hi,

The following two patches are intended to deal with the problem that some
CPU hotplug notifiers misbehave when they are called after tasks have been
frozen.

The first of them introduces special notifications that should allow subsystems
to distinguished normal CPU hotplug events from the ones that occur during
a suspend/resume, and the second makes the microcode driver actually use them.

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King

