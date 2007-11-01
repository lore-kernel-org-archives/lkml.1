Return-Path: <linux-kernel-owner+w=401wt.eu-S1759680AbXKAWoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759680AbXKAWoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 18:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbXKAWny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 18:43:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50808 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754390AbXKAWnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 18:43:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 0/3] Suspend and hibernation test facility
Date: Thu, 1 Nov 2007 23:57:27 +0100
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711012357.27797.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patches add a new testing facility for suspend and hibernation.

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


-- 
"Premature optimization is the root of all evil." - Donald Knuth

