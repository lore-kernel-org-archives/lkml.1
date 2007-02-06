Return-Path: <linux-kernel-owner+w=401wt.eu-S965540AbXBFWLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965540AbXBFWLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965545AbXBFWLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:11:52 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:39701 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965540AbXBFWLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:11:51 -0500
Date: Tue, 6 Feb 2007 23:11:56 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [2.6 patch] drivers/macintosh/mac_hid.c: make code static
Message-ID: <20070206221155.GG27397@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes some needlessly global code static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/macintosh/mac_hid.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.20-rc6-mm3/drivers/macintosh/mac_hid.c.old	2007-02-06 07:38:21.000000000 +0100
+++ linux-2.6.20-rc6-mm3/drivers/macintosh/mac_hid.c	2007-02-06 07:39:14.000000000 +0100
@@ -24,7 +24,7 @@
 
 #if defined(CONFIG_SYSCTL)
 /* file(s) in /proc/sys/dev/mac_hid */
-ctl_table mac_hid_files[] = {
+static ctl_table mac_hid_files[] = {
 	{
 		.ctl_name	= DEV_MAC_HID_MOUSE_BUTTON_EMULATION,
 		.procname	= "mouse_button_emulation",
@@ -53,7 +53,7 @@
 };
 
 /* dir in /proc/sys/dev */
-ctl_table mac_hid_dir[] = {
+static ctl_table mac_hid_dir[] = {
 	{
 		.ctl_name	= DEV_MAC_HID,
 		.procname	= "mac_hid",
@@ -65,7 +65,7 @@
 };
 
 /* /proc/sys/dev itself, in case that is not there yet */
-ctl_table mac_hid_root_dir[] = {
+static ctl_table mac_hid_root_dir[] = {
 	{
 		.ctl_name	= CTL_DEV,
 		.procname	= "dev",
@@ -129,7 +129,7 @@
 	return ret;
 }
 
-int __init mac_hid_init(void)
+static int __init mac_hid_init(void)
 {
 	int err;
 

