Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbXFDJP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbXFDJP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 05:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbXFDJPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 05:15:48 -0400
Received: from lazybastard.de ([212.112.238.170]:56795 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbXFDJPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 05:15:47 -0400
Date: Mon, 4 Jun 2007 11:11:06 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Sam Ravnborg <sam@ravnborg.org>, John Stoffel <john@stoffel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Jamie Lokier <jamie@shareable.org>,
       Artem Bityutskiy <dedekind@infradead.org>, CaT <cat@zip.com.au>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
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
Message-ID: <20070604091106.GE14823@lazybastard.org>
References: <20070603183845.GA8952@lazybastard.org> <20070603184303.GF8952@lazybastard.org> <200706032350.57556.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200706032350.57556.arnd@arndb.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 June 2007 23:50:55 +0200, Arnd Bergmann wrote:
> On Sunday 03 June 2007, Jörn Engel wrote:
> > +/**
> > + * struct logfs_device_ops - device access operations
> > + *
> > + * @read:                      read from the device
> > + * @write:                     write to the device
> > + * @erase:                     erase part of the device
> > + */
> > +struct logfs_device_ops {
> > +       int (*read)(struct super_block *sb, loff_t ofs, size_t len, void *buf);
> > +       int (*write)(struct super_block *sb, loff_t ofs, size_t len, void *buf);
> > +       int (*erase)(struct super_block *sb, loff_t ofs, size_t len);
> > +};
> 
> I wonder if there is a way to document the prototypes of these function
> pointers with kerneldoc, other than having a typedef for each.
> 
> What brought me to this point is that I first assumed they would return
> the number of bytes transferred, like read/write file operations, where
> your functions return zero on success.

I can just add a comment about the return code in the struct
documentation.  For the foreseeable future there will be exactly two
instances of this structure.  It's not as if every driver would
implement this.

Jörn

-- 
A defeated army first battles and then seeks victory.
-- Sun Tzu
