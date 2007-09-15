Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbXIOTcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbXIOTcr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 15:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbXIOTci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 15:32:38 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:7353 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbXIOTcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 15:32:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=f9rr497Rtu/utjWxGMn8O+jEKZB+10yhyU93efOmTJq62YBEpKbu+9x5sPwPmAHvBU7nwA7YxfdUVYe/AYekAmcyUTJturpQzgZCCXRD+WoCqzJV7qPk79RFvIjGqbdfAacDwDRbWyxfv3/g61BBcS/F20J0RzzZBv8Ot2QreRo=
Message-ID: <8b67d60709151232x7d43810frb13364b26da04c6b@mail.gmail.com>
Date: Sat, 15 Sep 2007 20:32:35 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
Subject: [PATCH 0/2] Add Maple bus support for the SEGA Dreamcast
Cc: "Paul Mundt" <lethal@linux-sh.org>, "Greg KH" <greg@kroah.com>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
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

I have the maplebus code a built in now as that seems the sane and
rational way to handle something like that - you either want the bus
or you don't.

maplebus.c: adds the core bus support
maple_keyb.c: adds the keyboard

Signed off by Adrian McMenamin <adrian@mcmen.demon.co.uk>
