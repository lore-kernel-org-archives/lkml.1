Return-Path: <linux-kernel-owner+w=401wt.eu-S1752048AbXCIIOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbXCIIOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 03:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbXCIIOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 03:14:19 -0500
Received: from cantor.suse.de ([195.135.220.2]:53873 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048AbXCIIOS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 03:14:18 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Amit Choudhary <amit2030@gmail.com>
Subject: Re: [PATCH] drivers/usb/serial/mos7840.c: check kmalloc() return value.
Date: Fri, 9 Mar 2007 09:14:24 +0100
User-Agent: KMail/1.9.1
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070308231833.69b0611e.amit2030@gmail.com>
In-Reply-To: <20070308231833.69b0611e.amit2030@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703090914.24242.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 9. März 2007 08:18 schrieb Amit Choudhary:
> Description: Check the return value of kmalloc() in function mos7840_get_reg(), in file drivers/usb/serial/mos7840.c.

No, this is wrong. You must catch this at the source. The driver
cannot function if this function always returns -ENOMEM. It makes
no sense to start up the device under these circumstances.

	Regards
		Oliver

