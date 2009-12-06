Return-Path: <linux-kernel-owner+w=401wt.eu-S1751572AbZLFFeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbZLFFeB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 00:34:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbZLFFd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 00:33:58 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:36201 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbZLFFd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 00:33:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=JBDCcCunMIeLGtBgvThZH0Vn56lc6Bck9DY5F+l98Wi9LhgRnDmmhy+PpbyVOvCwJz
         v2Pf/f21X1gMGHott3xUGWOwAKuOzkSB+BFeIR+s1svAx7KrM82++63UDt6IncDgTA8l
         rRHOFd3TysfOKzvW6SEAvDsdJrOVKHMPidCNc=
MIME-Version: 1.0
From: "Ian E. Morgan" <penguin.wrangler@gmail.com>
Date: Sun, 6 Dec 2009 00:33:42 -0500
Message-ID: <2a6e8c0d0912052133v3e112bdbx2c95b17437bdd182@mail.gmail.com>
Subject: acerhdf: BIOS product mismatch due to whitespace
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

Having just upgraded my AOA150 to 2.6.32, acerhdf was complaining:

acerhdf: Acer Aspire One Fan driver, v.0.5.18
acerhdf: unknown (unsupported) BIOS version Acer/AOA150
/v0.3310, please report, aborting!

DMI reports the product as "AOA150         " (i.e. 9 spaces after the
6-character model name). This causes the product match to fail, so I
had to use force_product="AOA150".

acerhdf: Acer Aspire One Fan driver, v.0.5.18
acerhdf: forcing BIOS product: AOA150

Then all was happy again. Any chance you could strip leading/trailing
whitespace in the product match to avoid this issue?

-- 
Ian Morgan
