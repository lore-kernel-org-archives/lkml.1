Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbZJQCDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbZJQCDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 22:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbZJQCDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 22:03:15 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:45858 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbZJQCDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 22:03:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=jbpr2iW+v7+1/PaP5kNPntss4WMEvfdDwBUNTVGXiGs/JrrCHaJvs3g+k0V7aK1hrg
         eQes0H2+gj+1yZ07n+Id5wCS2wEOldm2gBbmn87+A3ESPE7D7l/86banCyQjcvrA5Ava
         Js2DlCrmDyMbhyvLELaOoH/HkXt06q1TNlkC4=
MIME-Version: 1.0
Date: Fri, 16 Oct 2009 22:03:18 -0400
X-Google-Sender-Auth: ce92567c97c0af57
Message-ID: <cb0375e10910161903p59e74f1bx3a711a468bba8dab@mail.gmail.com>
Subject: 2.6.32-rc3 regression (I think): i915 framebuffer doesn't work
From: Andrew Lutomirski <luto@mit.edu>
To: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Somewhere between 2.6.32-rc2 and 2.6.32-rc3 (I think -- it might have
been a bit earlier), the framebuffer stopped working.  I see this
because Plymouth (F11) boots in test mode not graphical mode.  The
exact same userspace on 2.6.31 works fine.

(This seems to be getting worse.  Eric Anholt's for-linus worked
yesterday with text mode plymouth but now just hangs using the same
image -- I don't have any good explanation for that one.)

This is a Lenovo X200s, which has a GM45.

Thanks,
Andy
