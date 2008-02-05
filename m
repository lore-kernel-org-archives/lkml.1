Return-Path: <linux-kernel-owner+w=401wt.eu-S1758447AbYBEQFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447AbYBEQFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbYBEQFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:05:30 -0500
Received: from mail.ku-gbr.de ([81.3.11.18]:56946 "EHLO ku-gbr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752535AbYBEQF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:05:29 -0500
Date: Tue, 5 Feb 2008 17:05:18 +0100
From: Konstantin Kletschke <lists@ku-gbr.de>
To: Daniel Drake <dsd@gentoo.org>
Cc: Xavier Bestel <xavier.bestel@free.fr>, linux-kernel@vger.kernel.org
Subject: Re: [Patch 1/1] Nikon D80 usb-storage quirk needs modified, new FW
Message-ID: <20080205160518.GA7000@anita>
Mail-Followup-To: Daniel Drake <dsd@gentoo.org>,
	Xavier Bestel <xavier.bestel@free.fr>, linux-kernel@vger.kernel.org
References: <20080205124343.GB6638@anita> <1202218008.23816.9.camel@skunk.anacadf.mentorg.com> <20080205141841.GA6791@anita> <47A87236.4000204@gentoo.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <47A87236.4000204@gentoo.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Am 2008-02-05 14:27 +0000 schrieb Daniel Drake:


> it is whitespace-corrupted and hence will not apply. You should also submit 

ARGH! May be copy&paste with vim/xterm caused this. Is this better?
Anything else should have created a clean patch *mumblegrumble*

> it directly to the usb-storage maintainer with the linux-usb (and maybe the 
> usb-storage) list on CC.

I will see, I did not yet.

Konsti


-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF

--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="usb.patch"

--- linux-2.6.23/drivers/usb/storage/unusual_devs.h_orig	2008-02-05 13:33:55.010623616 +0100
+++ linux-2.6.23/drivers/usb/storage/unusual_devs.h	2008-02-05 13:32:22.926623601 +0100
@@ -342,7 +342,7 @@
 		US_FL_FIX_CAPACITY),
 
 /* Reported by Emil Larsson <emil@swip.net> */
-UNUSUAL_DEV(  0x04b0, 0x0411, 0x0100, 0x0101,
+UNUSUAL_DEV(  0x04b0, 0x0411, 0x0100, 0x0110,
 		"NIKON",
 		"NIKON DSC D80",
 		US_SC_DEVICE, US_PR_DEVICE, NULL,

--fdj2RfSjLxBAspz7--
