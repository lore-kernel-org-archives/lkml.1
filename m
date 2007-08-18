Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbXHRQIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbXHRQIb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 12:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755610AbXHRQIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 12:08:22 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:51511 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311AbXHRQIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 12:08:22 -0400
Message-Id: <200708181608.l7IG8Jmm006141@dell2.home>
X-Mailer: exmh version 2.4 05/15/2001 with nmh-1.1
To: linux-kernel@vger.kernel.org
Subject: power off disk drives while running
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Sat, 18 Aug 2007 12:08:19 -0400
From: "Marty Leisner" <leisner@rochester.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


In embedded system design, it may be useful to poweroff the disks (as opposed
to merely spinning them down).  We want to leave the system running while
the disk is powered down, and let the disk powerup when it needs to be 
spun up.

While the "power off mechanism" would be platform dependent, is there a
generic path to announce "prepare for power going away"?


marty

