Return-Path: <linux-kernel-owner+w=401wt.eu-S1761429AbXHAJAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761429AbXHAJAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 05:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756629AbXHAJAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 05:00:39 -0400
Received: from plasma-gate.weizmann.ac.il ([132.77.150.54]:60447 "EHLO
	plasma-gate.weizmann.ac.il" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756473AbXHAJAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 05:00:38 -0400
X-Greylist: delayed 513 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Aug 2007 05:00:37 EDT
Message-ID: <46B049AE.1020607@stambulchik.net>
Date: Wed, 01 Aug 2007 11:51:58 +0300
From: Evgeny Stambulchik <evgeny@stambulchik.net>
User-Agent: Thunderbird 2.0.0.4 (X11/20070704)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, r.gerlach@snafu.de
Subject: Re: [RFC] tablet buttons driver for fujitsu siemens laptops
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Just wanted to mention that the driver by Robert Gerlach also works[1] 
with a Fujitsu P1610 convertible, after a trivial modification:

static struct keymap_entry keymap_t1610[] = {
     { 0x0010, KEY_SCROLLDOWN },
     { 0x0020, KEY_SCROLLUP },
     { 0x0040, KEY_DIRECTION },
     { 0x0080, KEY_FN },
     { 0x8000, KEY_MENU },
     { 0x0400, KEY_KBDILLUMTOGGLE },
     { 0x0000, 0},
};

[1] evtest reports all events correctly and I can access them from user 
space, however, acpi_listen seems to be not getting those... Perhaps 
something trivial?

Regards,

Evgeny
