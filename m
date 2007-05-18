Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbXERU13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbXERU13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 16:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbXERU1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 16:27:23 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:54000 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbXERU1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 16:27:22 -0400
Date: Fri, 18 May 2007 22:27:06 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: John Sigler <linux.kernel@free.fr>
cc: linux-kernel@vger.kernel.org
Subject: Re: Dumping the checksums in a module
In-Reply-To: <464DC019.6010008@free.fr>
Message-ID: <Pine.LNX.4.61.0705182225450.9015@yvahk01.tjqt.qr>
References: <464DC019.6010008@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 18 2007 17:02, John Sigler wrote:
>
> I'm getting "disagrees about version of symbol struct_module" messages,
> and I'm trying to understand why.
>
> As far as I understand (which is not very far), if I define
> CONFIG_MODVERSIONS, then checksums for various functions (all exported
> functions?) and various structures (which ones?) will be included inside
> the kernel image, and written to Module.symvers. When an out-of-tree
> module is built, it will also include these checksums.
>
> How do I list the checksums within a module?
>
> Is there a simpler way to list all the checksums?

22:25 ichi:~ > modinfo aes
srcversion:     8CB82B3A254D5A950FD0D14

I think this one checksum is computed out of all functions that
the module uses.


	Jan
-- 
