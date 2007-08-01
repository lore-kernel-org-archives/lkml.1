Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687AbXHAVbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbXHAVbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 17:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbXHAVbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 17:31:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37190 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbXHAVbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 17:31:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 0/3] Freezer: Use wait queue instead of busy looping
Date: Wed, 1 Aug 2007 23:28:23 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200708012328.23939.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The patches in the next three messages do the following:
* make the freezer a bit more verbose
* make try_to_freeze_tasks() go to sleep while waiting for tasks to enter
  the refrigerator instead of busy looping
* make try_to_freeze_tasks() measure the time of freezing, regardless of
  whether or not it is successful

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

