Return-Path: <linux-kernel-owner+w=401wt.eu-S1756441AbYHTBLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbYHTBLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 21:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbYHTBKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 21:10:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:48484 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbYHTBK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 21:10:29 -0400
Date: Tue, 19 Aug 2008 18:07:52 -0700
From: greg@kroah.com
To: Jeff Garzik <jgarzik@pobox.com>,
       Linux USB kernel mailing list <linux-usb@vger.kernel.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Denis Joseph Barrow <D.Barow@option.com>
Subject: [patch 01/02] hso: icon 322 detection fix
Message-ID: <20080820010752.GB3365@kroah.com>
References: <20080820010353.593820280@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hso-icon-322-detection-fix.patch"
In-Reply-To: <20080820010738.GA3365@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Joseph Barrow <D.Barow@option.com>

Fixes Icon-322 detection.

Signed-off-by: Denis Joseph Barrow <D.Barow@option.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/usb/hso.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -397,7 +397,7 @@ static const struct usb_device_id hso_id
 	{default_port_device(0x0af0, 0xc031)},	/* Icon-Edge */
 	{icon321_port_device(0x0af0, 0xd013)},	/* Module HSxPA */
 	{icon321_port_device(0x0af0, 0xd031)},	/* Icon-321 */
-	{default_port_device(0x0af0, 0xd033)},	/* Icon-322 */
+	{icon321_port_device(0x0af0, 0xd033)},	/* Icon-322 */
 	{USB_DEVICE(0x0af0, 0x7301)},		/* GE40x */
 	{USB_DEVICE(0x0af0, 0x7361)},		/* GE40x */
 	{USB_DEVICE(0x0af0, 0x7401)},		/* GI 0401 */

-- 
