Return-Path: <linux-kernel-owner+w=401wt.eu-S1759595AbZKYTgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595AbZKYTgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 14:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758746AbZKYTgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 14:36:21 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:60502 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400AbZKYTgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 14:36:21 -0500
Message-ID: <524c95d0f11a150a1bd9a68609dbe41e.squirrel@intranet.cs.nmsu.edu>
Date: Wed, 25 Nov 2009 12:05:28 -0700
Subject: What's needed in a driver to start a console on a framebuffer
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm still playing around with the G13 driver and have everything worked
out except how I want to handle graphics and console.

In the driver I have a framebuffer device as well (it can't be a separate
device due to the way the messages are handled). This portion of the
driver is based on fbdefio.

Where I'm stuck is testing a console on the framebuffer. Everything I've
looked at assumes that a console is started at boot time or when the
driver is loaded.

I've thought about modifying the fbcon map, but I'd like this to happen
when the G13 is plugged in rather than at boot.

I noticed that fbcon watches for FB_EVENT_SET_CONSOLE_MAP and I could use
that to remap a console.

Any suggestions on how to approach this?

Thanks,

Rick

