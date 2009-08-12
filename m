Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbZHLO0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbZHLO0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 10:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbZHLO0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 10:26:45 -0400
Received: from mail.cs.nmsu.edu ([128.123.64.3]:34154 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbZHLO0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 10:26:44 -0400
Message-ID: <40c00347a27f37e06686be80de0adcf6.squirrel@intranet.cs.nmsu.edu>
Date: Wed, 12 Aug 2009 08:26:45 -0600
Subject: Event notification when sysfs attribute changes
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Linux USB" <linux-usb@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to allow userspace applications to track and display state
changes (without polling) in a driver that exports attributes via sysfs.

What is the best way to notify userspace applications when a sysfs
exported attribute changes?

In particular I wanted to drive the notification in the *_store() function
of the sysfs attribute.

Also, ideally, the mechanism would allow multiple userspace applications
to hook into the notification.

Thanks,

Rick


