Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbXGHKjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbXGHKjQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 06:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbXGHKjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 06:39:04 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:54283 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600AbXGHKjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 06:39:03 -0400
Date: Sun, 8 Jul 2007 12:39:28 +0200
From: DervishD <lkml@dervishd.net>
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: cdparanoia not setting count and/or reply_len properly
Message-ID: <20070708103928.GA20349@DervishD>
Mail-Followup-To: Linux-kernel <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi all :)

    I know, this has been treated on the list before (year 2005) but
without any real solution I'm aware of.

    I'm running kernel 2.6.20.14, and I have an ATAPI DVD writer that I
use with an IDE-to-USB adapter, so it appears as an SCSI drive to the
kernel.

    Anytime I rip anything with it, the log fills with the same message:
some numbers about a certain number of bytes and the old friend message
that I've put in the subject.

    I assume that the warning makes sense, but the fact is that my log
is full with the same message, the ripping is correct (so cdparanoia is
working OK WRT ripping) and if weren't for the printk_ratelimit, the
system will freeze.

    I don't know if cdparanoia should be fixed, but certainly the
warning could be issued only if CONFIG_SCSI_VERBOSE is set. This way you
will have the message if something goes wrong and you want more info,
but in cases where the warning is harmless your log will be clean...

    Anyway, this message is not for make suggestions, but for asking for
information: why is this warning happening? naugthy cdparanoia? naughty
kernel? I'm a bit confused and I want to use my external DVD drive for
ripping from time to time, to "exercise" it...

    Thanks a lot in advance :)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
