Return-Path: <linux-kernel-owner+w=401wt.eu-S1753663AbYGDUGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbYGDUGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 16:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbYGDUGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 16:06:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbYGDUGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 16:06:24 -0400
Date: Fri, 4 Jul 2008 15:59:40 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
       gregkh@suse.de
Subject: Re: usb-storage: quirk around v1.11 firmware on Nikon D4
Message-ID: <20080704195940.GA17510@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-usb@vger.kernel.org, gregkh@suse.de
References: <20080704193323.GA19712@redhat.com> <20080704194207.GE24665@one-eyed-alien.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080704194207.GE24665@one-eyed-alien.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb-storage: quirk around v1.11 firmware on Nikon D40

https://bugzilla.redhat.com/show_bug.cgi?id=454028
Just as in earlier firmware versions, we need to perform this
quirk for the latest version too.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 39a7c11..1a497e9 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -358,7 +358,7 @@ UNUSUAL_DEV(  0x04b0, 0x040f, 0x0100, 0x0200,
 		US_FL_FIX_CAPACITY),
 
 /* Reported by Emil Larsson <emil@swip.net> */
-UNUSUAL_DEV(  0x04b0, 0x0411, 0x0100, 0x0110,
+UNUSUAL_DEV(  0x04b0, 0x0411, 0x0100, 0x0111,
 		"NIKON",
 		"NIKON DSC D80",
 		US_SC_DEVICE, US_PR_DEVICE, NULL,

-- 
http://www.codemonkey.org.uk
