Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277Ab0AZXvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab0AZXvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:51:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740Ab0AZXoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:44:04 -0500
Received: from kroah.org ([198.145.64.141]:35398 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729Ab0AZXn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:56 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:29 2010
Message-Id: <20100126233929.150779408@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Elliott Sales de Andrade <quantum.analyst@gmail.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [63/98] Input: i8042 - add Dritek quirk for Acer Aspire 5610.
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Elliott Sales de Andrade <quantum.analyst@gmail.com>

commit e6edbdc52bc0755cbfe0721ca91d4fd87649bc13 upstream.

Signed-off-by: Elliott Sales de Andrade <quantum.analyst@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/serio/i8042-x86ia64io.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -524,6 +524,13 @@ static const struct dmi_system_id __init
  */
 static const struct dmi_system_id __initconst i8042_dmi_dritek_table[] = {
 	{
+		/* Acer Aspire 5610 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5610"),
+		},
+	},
+	{
 		/* Acer Aspire 5630 */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),


