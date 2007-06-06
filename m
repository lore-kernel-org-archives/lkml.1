Return-Path: <linux-kernel-owner+w=401wt.eu-S1764671AbXFFLeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764671AbXFFLeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 07:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761673AbXFFLeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 07:34:04 -0400
Received: from lazybastard.de ([212.112.238.170]:48646 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831AbXFFLeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 07:34:01 -0400
Date: Wed, 6 Jun 2007 13:29:01 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Paulo Marques <pmarques@grupopie.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Sam Ravnborg <sam@ravnborg.org>, John Stoffel <john@stoffel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Jamie Lokier <jamie@shareable.org>,
       Artem Bityutskiy <dedekind@infradead.org>, CaT <cat@zip.com.au>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       David Weinehall <tao@acc.umu.se>, Arnd Bergmann <arnd@arndb.de>,
       Willy Tarreau <w@1wt.eu>, Kyle Moffett <mrmacman_g4@mac.com>,
       Dongjun Shin <djshin90@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Bill Davidsen <davidsen@tmr.com>, Thomas Gleixner <tglx@linutronix.de>,
       Albert Cahalan <acahalan@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Roland Dreier <rdreier@cisco.com>,
       Ondrej Zajicek <santiago@crfreenet.org>,
       Ulisses Furquim <ulissesf@gmail.com>
Subject: Re: [Patch 05/18] fs/logfs/logfs.h
Message-ID: <20070606112901.GA3764@lazybastard.org>
References: <20070603183845.GA8952@lazybastard.org> <20070603184303.GF8952@lazybastard.org> <46669A89.3010500@grupopie.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46669A89.3010500@grupopie.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 June 2007 12:29:13 +0100, Paulo Marques wrote:
> Jörn Engel wrote:
> >--- /dev/null	2007-03-13 19:15:28.862769062 +0100
> >+++ linux-2.6.21logfs/fs/logfs/logfs.h	2007-06-03 
> >19:34:07.000000000 +0200
> >@@ -0,0 +1,398 @@
> >+/*
> >+ * fs/logfs/logfs.h
> >+ *
> >+ * As should be obvious for Linux kernel code, license is GPLv2
> >+ *
> >+ * Copyright (c) 2005-2007 Joern Engel
> >+ *
> >+ * Private header for logfs.
> >+ */
> >+#ifndef fs_logfs_logfs_h
> >+#define fs_logfs_logfs_h
> >+
> >+#define __CHECK_ENDIAN__
> >+
> >+
> >+#include <linux/crc32.h>
> >+#include <linux/fs.h>
> >+#include <linux/kallsyms.h>
> 
> Including kallsyms.h is not really needed in this header file, is it?

Another piece of historic cruft to remove.  Thanks for spotting.

Jörn

-- 
Joern's library part 5:
http://www.faqs.org/faqs/compression-faq/part2/section-9.html
