Return-Path: <linux-kernel-owner+w=401wt.eu-S1758955AbZJHWQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955AbZJHWQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 18:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757470AbZJHWQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 18:16:47 -0400
Received: from mail-yw0-f182.google.com ([209.85.211.182]:51693 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbZJHWQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 18:16:46 -0400
X-Greylist: delayed 1809 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Oct 2009 18:16:46 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=CyHJPWj+sf5pd6o+4abs+p9wMp5strgUvcV4KrpNpbrNZlzaZVyCNuAf6si4D1u1OG
         FFl/sBGvSj1Z4qJB2r4VvHa79YHhQNMj3lLXDnwLK1Rkb2N3Vr8a0LXRmGzuTLcfdh01
         2u+fo5u5JSTSYrHaRI2/Fgj5jtWmDEMXWOIAE=
MIME-Version: 1.0
Date: Thu, 8 Oct 2009 14:46:00 -0700
Message-ID: <dd18b0c30910081446y3d7284cfnac08003ed22ba374@mail.gmail.com>
Subject: ACPI Warning for \_SB_.BAT0._BIF: Converted Buffer to expected String 
	at index 9 (20090903/nsrepair-132)
From: Justin Mattock <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

just pulled and this showed up:

[    8.899845] ACPI Warning for \_SB_.BAT0._BIF: Converted Buffer to
expected String at index 9 (20090903/nsrepair-132)
[    8.920884] ACPI Warning for \_SB_.BAT0._BIF: Converted Buffer to
expected String at index 10 (20090903/nsrepair-132)
[    8.941465] ACPI Warning for \_SB_.BAT0._BIF: Converted Buffer to
expected String at index 11 (20090903/nsrepair-132)
[    8.961325] ACPI Warning for \_SB_.BAT0._BIF: Converted Buffer to
expected String at index 12 (20090903/nsrepair-132)

last good commit I have is:
2.6.31-rc8-00039-g03c3bbc
Ill try a bisect, but in the process
of doing another for
http://bugzilla.kernel.org/show_bug.cgi?id=14267

-- 
Justin P. Mattock
