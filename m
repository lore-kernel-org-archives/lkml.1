Return-Path: <linux-kernel-owner+w=401wt.eu-S1759705AbZKFUGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759705AbZKFUGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 15:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759561AbZKFUGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 15:06:18 -0500
Received: from mail.gmx.net ([213.165.64.20]:41801 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759392AbZKFUGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 15:06:17 -0500
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="iso-8859-1"
Date: Fri, 06 Nov 2009 21:06:20 +0100
From: "Martin Schleier" <drahemmaps@gmx.net>
In-Reply-To: <20091106182218.43940287@lxorguk.ukuu.org.uk>
Message-ID: <20091106200620.179910@gmx.net>
MIME-Version: 1.0
References: <20091106154911.29400@gmx.net>
	<20091106155937.11d95279@lxorguk.ukuu.org.uk>	<20091106165731.26800@gmx.net>
 <20091106182218.43940287@lxorguk.ukuu.org.uk>
Subject: Re: i686 quirk for AMD Geode
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Authenticated: #35928486
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1/1oaRQy/H1jSyCwX8JPwk0/plYp5y2vdQl0kCMW/
 hbN9H34uEPXkHj8CBoMQ7QMumL1ZZQ4Y1kwA== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: 0uyWHgBmbXB+TMNLFjY2MtYiLyUmZYit
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Nov 2009 18:22:18 Alan Cox wrote:
> > If it wasn't riddled with 19 errors (not bad for only 133 lines),
> > I would have bothered to remove these irrelevant lines.
> 
> Checkpatch is just formatting - its just an aide nothing more.
> It's not remotely useful to bother with them for stuff that is
> basically sanely formatted until such point as someone is actually
> sure the patch is worth going into the tree.

the utility is called checkpatch and not checkstyle or checkformatting.
And there's a good reason behind this decision, because it does
more than just checking style.

e.g:
 - correct use of some blackfin hi/lo macros.
 - if certain data structures are declared as const
   (struct seq_operations/file_operations)
 - correct use of NR_CPUS is usually wrong
 - complains about in_atomic() outside core kernel code
 - warns about LINUX_VERSION_CODE, #if 0,
   volatile or deprecated functions.
 - informs about needless kfree/usb_free_urb checks
 - etc...

and I'm sure that future modifications will add more
useful functionality _checks_ to many more _common pitfalls_ 
areas.
-- 
DSL-Preisknaller: DSL Komplettpakete von GMX schon für 
16,99 Euro mtl.!* Hier klicken: http://portal.gmx.net/de/go/dsl02
