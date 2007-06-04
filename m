Return-Path: <linux-kernel-owner+w=401wt.eu-S1760684AbXFDVZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684AbXFDVZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 17:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112AbXFDVZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 17:25:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40853 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbXFDVZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 17:25:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 0/2] PM: Hibernation and suspend notifiers
Date: Mon, 4 Jun 2007 23:25:28 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706042325.28965.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The first of the following two patches introduces hibernation and suspend
notifiers that can be used by subsystems to perform tasks related to suspend
and/or hibernation that cannot be done from device drivers' .suspend() and
.resume() callbacks.

The second one uses the notifiers to disable the user mode helper functionality
before a hibernation/suspend.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

