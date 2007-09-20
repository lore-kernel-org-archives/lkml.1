Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbXITL3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbXITL3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 07:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbXITL3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 07:29:42 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:21121 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbXITL3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 07:29:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=XQ70v2V15Pfx7E06AVjNKIs64BpKCKR3mXpa5o1Zzd/eHONh7I+et6yLJ6D7A5MUqhfbcVIl9ZomMRep/pLxdtW0aMdK1vb7rZgpQZkPcmqTjitRTNPiL9gx7MR5Rl+Dxg8FQzOYUbbEvfJh6wuHXWOBeZMjZQ7H/DSAUqjTVbE=
Message-ID: <8b67d60709200429y2118d943rcddf2b0fa31a5502@mail.gmail.com>
Date: Thu, 20 Sep 2007 12:29:40 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
Subject: Fwd: [PATCH 0/3] Add Maple bus support for the SEGA Dreamcast - repost
Cc: "Greg KH" <greg@kroah.com>, "Paul Mundt" <lethal@linux-sh.org>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Arjan van de Ven" <arjan@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Maple bus is SEGA's proprietary serial bus for peripherals
(keyboard, mouse, controller etc). The bus is capable of some
(limited) hotplugging and operates at up to 2 M/bits.

Drivers of one sort or another existed/exist for 2.4 and a rudimentary
port, which didn't support the 2.6 device driver modei was also in
existence.

This driver - for the bus logic itself and for the keyboard (other
drivers will follow) are based on the code and concepts of those old
drivers but have lots of completely rewritten parts.

I have the maplebus code as a built in now as that seems the sane and
rational way to handle something like that - you either want the bus
or you don't.

maplebus.c: adds the core bus support
maple_keyb.c: adds the keyboard

Signed off by Adrian McMenamin <adrian@mcmen.demon.co.uk>
