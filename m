Return-Path: <linux-kernel-owner+w=401wt.eu-S1761922AbXFBAjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761922AbXFBAjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 20:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754951AbXFBAj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 20:39:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58342 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891AbXFBAj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 20:39:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH -mm 0/2] PM: Hibernation and suspend notifiers (rev. 2)
Date: Sat, 2 Jun 2007 02:41:52 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
References: <200705272229.21263.rjw@sisk.pl>
In-Reply-To: <200705272229.21263.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706020241.53788.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the second revision of the patches that introduce hibernation and
suspend notifiers.

Generally, I have followed the Alan's suggestion to use a blocking notifier
chain and the Pavel's suggestion to limit the number of events.  Also, I've
dropped the patch to disable the requesting of firmware.

Comments welcome.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

