Return-Path: <linux-kernel-owner+w=401wt.eu-S1760039AbXKCTmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039AbXKCTmu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 15:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756777AbXKCTmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 15:42:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57818 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756725AbXKCTml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 15:42:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 0/3] Suspend and hibernation test facility (rev. 2)
Date: Sat, 3 Nov 2007 20:54:39 +0100
User-Agent: KMail/1.9.5
Cc: Johannes Berg <johannes@sipsolutions.net>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711032054.40195.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the second iteration of the patches that add a new testing facility for
suspend and hibernation.

The first patch adds the possibility to test the suspend (STD) core code
without actually suspending, which is useful for tracking problems with drivers
etc.

The second one modifies the hibernation core so that it can use the same
facility (it's a bit more powerful than the existing hibernation test modes,
since they really can't test the ACPI global methods).

The third one modified documentation in accordance with the two previous ones.

Comments welcome.

Greetings,
Rafael

