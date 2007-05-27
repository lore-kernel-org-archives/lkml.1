Return-Path: <linux-kernel-owner+w=401wt.eu-S1759044AbXE0U2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759044AbXE0U2W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 16:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbXE0U2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 16:28:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54528 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012AbXE0U2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 16:28:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH -mm 0/3] PM: Hibernation and suspend notifiers
Date: Sun, 27 May 2007 22:29:20 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705272229.21263.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The first of the following three patches introduces notifier chaing that can be
used by subsystems to prefore some hibernation-related or suspend-related
operations independent of device drivers' .suspend() and .resume() callbacks.

The next two patches use this mechanism for disabling/enabling the usermode
helper and firmware requesting functionality before/after (respectively) the
hibernation or suspend.

Comments welcome.

Greetings,
Rafael

