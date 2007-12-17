Return-Path: <linux-kernel-owner+w=401wt.eu-S935940AbXLQXfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935940AbXLQXfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 18:35:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757532AbXLQXex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 18:34:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44256 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbXLQXew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:34:52 -0500
Message-ID: <47670759.4040208@zytor.com>
Date: Mon, 17 Dec 2007 15:33:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
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
References: <200712172228.lBHMSW3i019555@tazenda.hos.anvin.org> <Pine.LNX.4.64.0712180028430.32270@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0712180028430.32270@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Dec 17 2007 13:53, H. Peter Anvin wrote:
> 
>> index 0000000..fd46b3d
>> --- /dev/null
>> +++ b/kernel/timeconst.pl
> 
> Could this live in scripts/ too? (And use CodingStyle?)

Why should it live in scripts/ rather than where it is used?  scripts/ 
is used either for global scripts or scripts which are used manually. 
Other scripts are not centralized there.

CodingStyle is applicable to C code, not to scripts as far as I can tell.

	-hpa

