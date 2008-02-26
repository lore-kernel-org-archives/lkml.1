Return-Path: <linux-kernel-owner+w=401wt.eu-S1762661AbYBZVOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762661AbYBZVOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762354AbYBZVOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:14:31 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:32874 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760677AbYBZVO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:14:28 -0500
Message-ID: <f4fe1c2a0802261314i5c4c5738y2a3f0e1c8748ee60@mail.gmail.com>
Date: Tue, 26 Feb 2008 22:14:27 +0100
From: "=?UTF-8?Q?Szekeres_Istv=C3=A1n?=" <szekeres@iii.hu>
To: linux-kernel@vger.kernel.org
Subject: kernel losing printk messages?
Cc: jkosina@suse.cz
In-Reply-To: <f4fe1c2a0802261309s17aaf082w14525c1e2f3af2f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f4fe1c2a0802261309s17aaf082w14525c1e2f3af2f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

in 2.6.25-rc3 I'm trying to add support for an usb keyboard. While the
hid-input driver dumps a lot of debugging messages, lines seem to be
lost. Please see the lines shorter/longer than the average.

 Feb 26 21:57:20 rusalka kernel: [82279.097414]
drivers/hid/hid-input.c: Mapping: Keyboard.0000 ---> IGNORED
Feb 26 21:57:20 rusalka kernel: [82279.097419]
drivers/hid/hid-input.c: Mapping: Keyboard.0001 ---> IGNORED
 Feb 26 21:57:20 rusalka kernel: [82279.097425]
drivers/hid/hid-input.c: Mapping: Keyboard.0002 ---> IGNORED
Feb 26 21:57:20 rusalka kernel: [82279.097430] d7>[82279.234078]
drivers/hid/hid-input.c: Mapping: Consumer.01fc ---> IGNORED
 Feb 26 21:57:20 rusalka kernel: [82279.234083]
drivers/hid/hid-input.c: Mapping: Consumer.01fd ---> IGNORED
Feb 26 21:57:20 rusalka kernel: [82279.234088]
drivers/hid/hid-input.c: Mapping: Consumer.01fe ---> IGNORED
 Feb 26 21:57:20 rusalka kernel: [82279.234094]
drivers/hid/hid-input.c: Mapping: Consumer.01ff ---> IGNORED
...

Feb 26 21:57:20 rusalka kernel: [82279.234370]
drivers/hid/hid-input.c: Mapping: Consumer.0215 ---> IGNORED
 Feb 26 21:57:20 rusalka kernel: [82279.234376]
drivers/hid/hid-input.c: Mapping: Consumer.0216 ---> IGNORED
Feb 26 21:57:20 rusalka kernel: [82279.234381]
drivers/hid/hid-input.c: Mapping: Consumer.0217 ---> IGNORED
 Feb 26 21:57:20 rusalka kernel: <7Consumer.0227 ---> Key.Refresh
Feb 26 21:57:20 rusalka kernel: [82279.234480]
drivers/hid/hid-input.c: Mapping: Consumer.0228 ---> IGNORED
Feb 26 21:57:20 rusalka kernel: [82279.234485]
drivers/hid/hid-input.c: Mapping: Consumer.0229 ---> IGNORED
 Feb 26 21:57:20 rusalka kernel: [82279.234490]
drivers/hid/hid-input.c: Mapping: Consumer.022a ---> Key.Bookmarks

This is directly copied from /var/log/kern.log.

Is this a bug or a feature? :)

Thanks,
 Istvan
