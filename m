Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbXFDJdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbXFDJdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 05:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbXFDJde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 05:33:34 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:33740 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436AbXFDJdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 05:33:32 -0400
Date: Mon, 4 Jun 2007 10:17:47 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: =?utf-8?q?J=C3=B6rn_Engel?= <joern@lazybastard.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Sam Ravnborg <sam@ravnborg.org>, John Stoffel <john@stoffel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Jamie Lokier <jamie@shareable.org>,
       Artem Bityutskiy <dedekind@infradead.org>, CaT <cat@zip.com.au>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       David Weinehall <tao@acc.umu.se>, Willy Tarreau <w@1wt.eu>,
       Kyle Moffett <mrmacman_g4@mac.com>, Dongjun Shin <djshin90@gmail.com>,
       Pavel Machek <pavel@ucw.cz>, Bill Davidsen <davidsen@tmr.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Albert Cahalan <acahalan@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Roland Dreier <rdreier@cisco.com>,
       Ondrej Zajicek <santiago@crfreenet.org>,
       Ulisses Furquim <ulissesf@gmail.com>
Subject: Re: [Patch 05/18] fs/logfs/logfs.h
In-Reply-To: <200706032350.57556.arnd@arndb.de>
Message-ID: <Pine.LNX.4.61.0706041017270.20829@yvahk01.tjqt.qr>
References: <20070603183845.GA8952@lazybastard.org> <20070603184303.GF8952@lazybastard.org>
 <200706032350.57556.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>On Sunday 03 June 2007, Jörn Engel wrote:
>> +/**
>> + * struct logfs_device_ops - device access operations
>> + *
>> + * @read:                      read from the device
>> + * @write:                     write to the device
>> + * @erase:                     erase part of the device
>> + */
>> +struct logfs_device_ops {
>> +       int (*read)(struct super_block *sb, loff_t ofs, size_t len, void *buf);
>> +       int (*write)(struct super_block *sb, loff_t ofs, size_t len, void *buf);
>> +       int (*erase)(struct super_block *sb, loff_t ofs, size_t len);
>> +};
>
>I wonder if there is a way to document the prototypes of these function
>pointers with kerneldoc, other than having a typedef for each.
>
>What brought me to this point is that I first assumed they would return
>the number of bytes transferred, like read/write file operations, where
>your functions return zero on success.

read/write functions returning bytes written would return ssize_t,
just as vfs_read and vfs_write do.



	Jan
-- 
