Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbYFBQ1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbYFBQ1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 12:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbYFBQ1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 12:27:08 -0400
Received: from mail.aknet.ru ([78.158.192.26]:49525 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbYFBQ1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 12:27:07 -0400
Message-ID: <48441F62.1040602@aknet.ru>
Date: Mon, 02 Jun 2008 20:27:14 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dmitry Torokhov <dtor-oss@comcast.net>
CC: Takashi Iwai <tiwai@suse.de>, Linux kernel <linux-kernel@vger.kernel.org>
Subject: [patch] pcspkr: undepend of snd-pcsp
X-Enigmail-Version: 0.95.2
Content-Type: multipart/mixed;
 boundary="------------040709010602080901070607"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040709010602080901070607
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello.

It should be possible to build
pcspkr driver together with snd-pcsp.
Even though right now there is no
good plan to get these drivers to
work together, some things were done,
namely:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=16dc42e018c2868211b4928f20a957c0c216126c
and
https://bugzilla.redhat.com/show_bug.cgi?id=448425
which looks more or less sufficient.

And there was a discussion already:
http://kerneltrap.org/mailarchive/linux-kernel/2008/4/29/1652654

The attached patch allows pcspkr to
be built together with snd-pcsp.

Dmitry, could you please apply?

Signed-off-by: Stas Sergeev <stsp@aknet.ru>

--------------040709010602080901070607
Content-Type: text/x-patch;
 name="pcspkr_nodep.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pcspkr_nodep.diff"

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 3ad8bd9..432699d 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -15,7 +15,6 @@ if INPUT_MISC
 config INPUT_PCSPKR
 	tristate "PC Speaker support"
 	depends on PCSPKR_PLATFORM
-	depends on SND_PCSP=n
 	help
 	  Say Y here if you want the standard PC Speaker to be used for
 	  bells and whistles.

--------------040709010602080901070607--
