Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbYBQTwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbYBQTwe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYBQTw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:52:26 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:34011 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbYBQTw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:52:26 -0500
Date: Sun, 17 Feb 2008 20:52:35 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: kkeil@suse.de, isdn4linux@listserv.isdn4linux.de
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Subject: Plans for mISDN? Was: [PATCH 00/14] [ISDN] ...
Message-ID: <20080217195235.GN14588@uranus.ravnborg.org>
References: <098123kjff90231nv098233rnvd908u234@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <098123kjff90231nv098233rnvd908u234@garzik.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Karsten et al.

Seeing the work Jeff puts into ISDN I was wondering what are the
state of mISDN. Will we soon see mISDN hit the tree or has
development stalled?

I was wondering if Jeff should go for the much simpler patch:

diff --git a/drivers/isdn/Kconfig b/drivers/isdn/Kconfig
index 66f946a..e904e9e 100644
--- a/drivers/isdn/Kconfig
+++ b/drivers/isdn/Kconfig
@@ -4,6 +4,7 @@

 menuconfig ISDN
        tristate "ISDN support"
+       depends on BROKEN
        depends on NET
        depends on !S390
        ---help---

Especially considering the minimal feedback from the isdn
community and the existence of a total? replacement.

	Sam
