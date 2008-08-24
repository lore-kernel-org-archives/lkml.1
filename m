Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbYHXQYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbYHXQYZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 12:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbYHXQYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 12:24:16 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:50831 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbYHXQYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 12:24:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZPiG16cT5WgD/MXOHrjD097fKM7RiahZwPKBmwXGdTYjVyU5I1HjyuSVv5Qil7CC86
         8XNpgrif9/CnU1SvP69L8VXSJvKqCH37b7ppPd/6xikJFjo+TaS2fndqNCoKaUvgEMmp
         AlARse16J/4L1n8qf+U/T26lG7B0gTmat0k9w=
Message-ID: <922976dd0808240924n3b134ec6pb5451e269273810e@mail.gmail.com>
Date: Sun, 24 Aug 2008 18:24:14 +0200
From: krisje8 <krisje8@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Support for MCP78 SATA controller
In-Reply-To: <922976dd0808240919j656cef26uec4a06314ee653b6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <922976dd0808240919j656cef26uec4a06314ee653b6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

When trying to install Debian Lenny today on my new PC it booted the
installation, but failed to recognise the dvd drive, and I could not
continue the installer.
After asking for a solution on #debian at irc.debian.org
(irc.oftc.net), some users have tried to help me with this.
One of them tracked down some information, and suggested me to post to
this mailing list (his name was enouf).

This is the information that I got:

Motherboard: ASUS M3N78 Pro (according to enouf the sata controller is a MCP78)
DVD drive: ASUS DRW-2014

The manual of my motherboard:
http://dlsvr.asus.com/pub/ASUS/mb/socketAM2/M3N78_PRO/e3864_M3N78_PRO_manual.zip

He noticed upport for mcp77 and mcp79, but not for mcp78:
http://lxr.linux.no/linux+v2.6.26.3/drivers/ata/ahci.c
http://lxr.linux.no/linux+v2.6.26.3/drivers/net/forcedeth.c#L6007

And a review about my motherboard:
http://www.bjorn3d.com/read_pf.php?cID=1305

Best regards,
krisje8

P.S.: I am not a member of the mailing list, so if you have an answer
for me could you please CC me?
