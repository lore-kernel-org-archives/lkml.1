Return-Path: <linux-kernel-owner+w=401wt.eu-S965319AbXH0Vy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965319AbXH0Vy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933228AbXH0Voy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:44:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47335 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140AbXH0Vov convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:44:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 0/3] PM: Improve ACPI handling during suspend and hibernation (rev. 3)
Date: Mon, 27 Aug 2007 23:47:44 +0200
User-Agent: KMail/1.9.5
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708272347.45438.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The patches in this series are intended to improve the handling of the ACPI
platform during suspend and hibernation.

They do the following things:
* make hibernation_platform_enter() consistent with the sleep state entering
  code in kernel/power/main.c
* introduce global platform callbacks allowing us to handle ACPI in a more fine
  grained way during suspend and hibernation
* improve the handling of the system status indicator during suspend and
  hibernation.

Greetings,
Rafael

