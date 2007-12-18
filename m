Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbXLRMcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbXLRMcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 07:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbXLRMcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 07:32:46 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:50074 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbXLRMco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 07:32:44 -0500
Date: Tue, 18 Dec 2007 13:32:42 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>, Sam Ravnborg <sam@ravnborg.org>,
       Paul Mundt <lethal@linux-sh.org>, Richard Henderson <rth@twiddle.net>,
       Michael Starvik <starvik@axis.com>, David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH] Avoid overflows in kernel/time.c (version 3)
In-Reply-To: <47670759.4040208@zytor.com>
Message-ID: <Pine.LNX.4.64.0712181331240.32270@fbirervta.pbzchgretzou.qr>
References: <200712172228.lBHMSW3i019555@tazenda.hos.anvin.org>
 <Pine.LNX.4.64.0712180028430.32270@fbirervta.pbzchgretzou.qr>
 <47670759.4040208@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 17 2007 15:33, H. Peter Anvin wrote:
>> Could this live in scripts/ too? (And use CodingStyle?)
>
> Why should it live in scripts/ rather than where it is used?  scripts/ is used
> either for global scripts or scripts which are used manually. Other scripts are
> not centralized there.
>
> CodingStyle is applicable to C code, not to scripts as far as I can tell.
>
Checkpatch adheres to it. And indent, which is applicable to almost all
languages, is a strong point in CodingStyle.
