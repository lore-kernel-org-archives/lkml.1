Return-Path: <linux-kernel-owner+w=401wt.eu-S1752594AbZLVAp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbZLVAp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 19:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbZLVAp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 19:45:26 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:64929 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbZLVAp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 19:45:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:content-type;
        b=EPyPSc63tOsD8P5B7uxfmVC/iBethQq9A9n/ku5d7wiXfR23ey1SweKpTPIU4HLo2H
         QZIzeqhAAbz7v3O9TxcuWM7S1n9ZEAfcYJxMCRNbWcVGB/67Z9BVU+lsYyzk275DfQxi
         Fr6+f0DRbAY8nGMdt6ZX4DZMJbt4GxLCMABOU=
MIME-Version: 1.0
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 21 Dec 2009 19:45:03 -0500
X-Google-Sender-Auth: 693e0278512ba172
Message-ID: <cb0375e10912211645w1fecfafcj8f1c0ab9ce23b077@mail.gmail.com>
Subject: [2.6.33-rc1 regression] suspend doesn't work on X200s
To: linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all-

On Linus's tree from yesterday (2.6.33-rc1 plus a bit, I think) with
drm-next patched in, I can't suspend.  My sleep light starts blinking
(userspace does that, I think) and the screen goes blank, then the
caps lock and num lock lights blink once (this is supposed to happen
when suspending), and then the system freezes hard with the fan and
backlight still on and the suspend light still blinking.

I'm pretty sure this has nothing to do with drm changes, since I can
suspend fine on 2.6.32.1 with include/drm and drivers/drm copied from
the broken 2.6.33-rc1 + drm-next tree.

Thanks,
Andy
