Return-Path: <linux-kernel-owner+w=401wt.eu-S1760639AbYDBS6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760639AbYDBS6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758812AbYDBS6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:58:14 -0400
Received: from nn7.de ([85.214.94.156]:57068 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757394AbYDBS6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:58:13 -0400
Subject: 2.6.25 intended change: smc:kbd_backlight vs. smc::kbd_backlight ?
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Julien BLACHE <jb@jblache.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 02 Apr 2008 20:58:10 +0200
Message-Id: <1207162690.9669.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I am wondering whether the change from 

/sys/devices/platform/applesmc.768/leds/smc:kbd_backlight  (2.6.24) 
/sys/devices/platform/applesmc.768/leds/smc::kbd_backlight (2.6.25)

is intentional?

I recognized that it breaks current userspace applications changing the
keyboard background leds like pommed...

Soeren

