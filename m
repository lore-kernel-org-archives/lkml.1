Return-Path: <linux-kernel-owner+w=401wt.eu-S1759101AbZFNWhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101AbZFNWhV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 18:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbZFNWhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 18:37:10 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:35805 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbZFNWhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 18:37:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=cvaMDI5jQw85oxYl3gda+J2rtxcIiKRsyvqVQ+d4USOpGxUK6w7UEWtp45+HXKV3ds
         BNF6dfh94UPwXuSag+QFw4F/glgmEnN5YOjyy+1cjxSPAMgsuHCTrvSMuUeiW3KyjL6G
         fE7CFF8b0K0BdORooLSKxGaJQqd9QFIKZA9O0=
MIME-Version: 1.0
Date: Sun, 14 Jun 2009 15:37:10 -0700
Message-ID: <dd18b0c30906141537l2edb2002o6fd29dc1ea6c2190@mail.gmail.com>
Subject: finally no: ACPI: EC: GPE storm detected, disabling EC GPE
From: Justin Mattock <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After running kernel 2.6.30 for almost a week, Ive noticed
that the gpe storm being triggered has only gone
off once, during a cold boot, but after a reboot
did not return for the rest of the session, and for the last
two weeks(with 2.6.30-rc7 to linus's 2.6.30)
prior to that with 2.6.30-rc5 I was receiving this message
within an hour or so, vary consistent.

The only change that occurred with 2.6.30-rc5 to now
was I had decided to create a small system for myself,
but this time leave hal out of the picture.(acpid is present but
has only one rule "powerbtn" so I can shutdown the system).

Could it be possible that hal might have been causing this
gpe storm to be triggered?(or was this fixed by having a
new copy of udev?)

In any case thought I would send some info about what I'm
experiencing over here with 2.6.30.

-- 
Justin P. Mattock
