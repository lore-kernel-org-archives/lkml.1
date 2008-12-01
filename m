Return-Path: <linux-kernel-owner+w=401wt.eu-S1753218AbYLAS5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbYLAS5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 13:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbYLAS5C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 13:57:02 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:16905 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbYLAS5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 13:57:00 -0500
X-Greylist: delayed 4196 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Dec 2008 13:57:00 EST
Date: Mon, 1 Dec 2008 10:56:25 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, mtk.manpages@gmail.com,
       dl9pf@gmx.de, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: Re: Document hadling of bad memory
Message-Id: <20081201105625.25ee9f32.randy.dunlap@oracle.com>
In-Reply-To: <20081126161521.GC1983@elf.ucw.cz>
References: <20081126161521.GC1983@elf.ucw.cz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.49343362.00B2:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008 17:15:21 +0100 Pavel Machek wrote:

> Document how to deal with bad memory reported with memtest.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> diff --git a/Documentation/bad_memory.txt b/Documentation/bad_memory.txt
> new file mode 100644
> index 0000000..df84162
> --- /dev/null
> +++ b/Documentation/bad_memory.txt
> @@ -0,0 +1,45 @@
> +March 2008
> +Jan-Simon Moeller, dl9pf@gmx.de
> +
> +
> +How to deal with bad memory e.g. reported by memtest86+ ?
> +#########################################################
> +
> +There are three possibilities I know of:
> +
> +1) Reinsert/swap the memory modules
> +
> +2) Buy new modules (best!) or try to exchange the memory
> +   if you have spare-parts
> +
> +3) Use BadRAM or memmap
> +
> +This Howto is about number 3) .

No space between 3) and '.'.

> +
> +
> +BadRAM
> +######
> +BadRAM is the actively developed and available as kernel-patch
> +here:  http://rick.vanrein.org/linux/badram/
> +
> +For more details see the BadRAM documentation.
> +
> +memmap
> +######
> +
> +memmap is already in the kernel and usable as kernel-parameter at

                                                 a kernel parameter at

> +boot-time.  Its syntax is slightly strange and you may need to

   boot time.

> +calculate the values by yourself!

s/!/./

> +
> +Syntax to exclude a memory area (see kernel-parameters.txt for details):
> +memmap=<size>$<address>
> +
> +Example: memtest86+ reported here errors at address 0x18691458, 0x18698424 and

s/here //

> +         some others. All had 0x1869xxxx in common, so I chose a pattern of
> +         0x18690000,0xffff0000.

What is the 0xffff0000 for?  Needs explanation.

> +
> +With the numbers of the example above:
> +memmap=64K$0x18690000
> + or
> +memmap=0x10000$0x18690000
> +

Please lose the last empty line.

and thanks for the patch/new file.

---
~Randy
