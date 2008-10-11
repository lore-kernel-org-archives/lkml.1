Return-Path: <linux-kernel-owner+w=401wt.eu-S1755733AbYJKIvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbYJKIvU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 04:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbYJKIvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 04:51:12 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:22859 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbYJKIvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 04:51:11 -0400
X-Spam-Flag: NO
X-Spam-Score: -9.389
Message-ID: <48F068F8.8080102@tremplin-utc.net>
Date: Sat, 11 Oct 2008 10:51:04 +0200
From: Eric Piel <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.17) Gecko/20080929 Mandriva/2.0.0.17-2mdv2009.0 (2009.0) Thunderbird/2.0.0.17 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] HP-WMI: additional keycode (or typo)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Matthew,

On my HP 2510, pressing the (i) button generates an unknown keycode:
0x213b. So here is a patch adding support for it. However, as it seems
there is already support for a similar button connected to 0x231b as
keycode, I wonder if it could be a typo in the driver? If so, let me
know and I can redo the patch.

See you,
Eric

=
HP-WMI : add another keycode

On the hp nc2510, the (i) button generates a different keycode, add it
as KEY_INFO.

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
---
 drivers/misc/hp-wmi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/hp-wmi.c b/drivers/misc/hp-wmi.c
index 6d407c2..02329df 100644
--- a/drivers/misc/hp-wmi.c
+++ b/drivers/misc/hp-wmi.c
@@ -82,6 +82,7 @@ static struct key_entry hp_wmi_keymap[] = {
 	{KE_KEY, 0x03, KEY_BRIGHTNESSDOWN},
 	{KE_KEY, 0x20e6, KEY_PROG1},
 	{KE_KEY, 0x2142, KEY_MEDIA},
+	{KE_KEY, 0x213b, KEY_INFO},
 	{KE_KEY, 0x231b, KEY_HELP},
 	{KE_END, 0}
 };
