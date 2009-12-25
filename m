Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbZLYBLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbZLYBLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 20:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbZLYBLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 20:11:21 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:46472 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbZLYBLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 20:11:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=agIdhjFG8lfkjczXQrXzo/hkQgZvS828Q5nibG2Q3fDoyFBjp4VWulRK0XsaZXGh1L
         ty7FyLay/t4GXxYVC8TyJtUuyW9X6rKavMRPP6aAwGcQJ800E+WLSAIapimYlaFujsCQ
         6GxH6OiEOt8Q1TLK1lQOt3C+1GXj/potdyRp4=
MIME-Version: 1.0
Date: Fri, 25 Dec 2009 02:11:17 +0100
Message-ID: <2d0a357f0912241711o97011od6c1750d7acf8b9e@mail.gmail.com>
Subject: [2.6.33-rc2] ACPI problems on HP nc6400 notebook
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: len.brown@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I build linux-2.6.33-rc2 on a Debian/sid 32-bit host.
Unfortunately, this kernel falls in an unusable state (sort of loop)
and does not a normal startup.

With this setting (see below), I hoped to catch the early
boot-messages (but, no success):

# cat /etc/default/bootlogd
# Run bootlogd at startup ?
BOOTLOGD_ENABLE=Yes

Finally, I could take a picture [1].
It seems to be that latest ACPI patches are breaking my system (speculating).

Q: How can I log such early boot (error) messages to give a detailled log?

Hope this helps fixing the problem.

Kind Regards,
- Sedat -


[1] http://files.iniza.org/linux-kernel/DSCN2134.JPG
