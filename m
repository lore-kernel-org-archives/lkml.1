Return-Path: <linux-kernel-owner+w=401wt.eu-S1757353AbXJKK6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbXJKK6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 06:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbXJKK6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 06:58:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61957 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbXJKK6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 06:58:23 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] FAT: Fix printk format strings.
To: Vegard Nossum <vegard.nossum@gmail.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Thu, 11 Oct 2007 12:58:09 +0200
References: <9d2nm-1SV-11@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1Ifvk1-0000o5-VO@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX186SpB/mWuKHrKmgWAPovd8u5dRbi+cYk+ZW+Q
 hTMFKwh7+zBOheiF1PyMxLMM9S6HVweoa8/fYe0kE8DFl0yWn1
 z7SZTU/O30hDJazm3DCaw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum <vegard.nossum@gmail.com> wrote:

> This makes sure printk format strings contain no more than a single
> line.

>  printk(KERN_WARNING
> -                            "FAT: Did not find valid FSINFO signature.\n"
> +                            "FAT: Did not find valid FSINFO signature.\n");
> +                     printk(KERN_WARNING
>  "     Found signature1 0x%08x signature2 0x%08x"
>  " (sector = %lu)\n",

What about something like
"Fat32: Invalid FSINFO signatures 0x%08x, 0x%08x; expected 0x%08x, 0x%08\n" ?
or
"Fat32: Invalid FSINFO signatures 0x%08x, 0x%08x\n" ?
-- 
bus error. passengers dumped.

Friﬂ, Spammer: GYwky2@xvGdf6v.7eggert.dyndns.org
 fD8g@tfnrkqq.7eggert.dyndns.org VpcWe@h5ib4vef.7eggert.dyndns.org
