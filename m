Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbXK1GJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbXK1GJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 01:09:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbXK1GIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 01:08:52 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55028 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751229AbXK1GIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 01:08:51 -0500
Date: Tue, 27 Nov 2007 22:07:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
       Pierre Ossman <drzeus@drzeus.cx>, Marcel Holtmann <marcel@holtmann.org>
Cc: linux-kernel@vger.kernel.org
Subject: m68k build failure
Message-Id: <20071127220723.e2e3d0b4.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Current Linus tree give me this, with m68k allmodconfig:

FATAL: drivers/bluetooth/btsdio: sizeof(struct sdio_device_id)=12 is not a modulo of the size of section __mod_sdio_device_table=30.
Fix definition of struct sdio_device_id in mod_devicetable.h

which I haven't seen before.  Any ideas?

Thanks.
