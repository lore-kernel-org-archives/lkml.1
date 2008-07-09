Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbYGINGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbYGINGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 09:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbYGINF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 09:05:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34350 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbYGINFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 09:05:55 -0400
Subject: Re: [PATCH] dsp56k: use request_firmware
From: David Woodhouse <dwmw2@infradead.org>
To: Fredrik Noring <noring@nocrew.org>
Cc: Jaswinder Singh <jaswinder@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Lars Brinkhoff <lars@nocrew.org>,
       Tomas =?ISO-8859-1?Q?Sk=E4re?= <tomas@nocrew.org>
In-Reply-To: <35647D7D-85D1-4308-B3A1-63CDCC3F14F7@nocrew.org>
References: <1215253496.7816.7.camel@jaswinder.satnam>
	 <A3D470E0-953E-40D6-BF5A-D06B76451154@nocrew.org>
	 <1215357224.2817.2.camel@jaswinder.satnam>
	 <43A34816-3B93-4D05-AE0A-65C0FBF35589@nocrew.org>
	 <1215358732.2817.11.camel@jaswinder.satnam>
	 <1215363247.3189.113.camel@shinybook.infradead.org>
	 <35647D7D-85D1-4308-B3A1-63CDCC3F14F7@nocrew.org>
Content-Type: text/plain
Date: Wed, 09 Jul 2008 14:05:50 +0100
Message-Id: <1215608750.11567.177.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-07-06 at 20:29 +0200, Fredrik Noring wrote:
> That's right. Sorry I was unclear. However, after some digging on  
> floppy backups from the past, I've found a DSP56k loader routine  
> that's probably close if not identical to the assembled version  
> included with the kernel. Please see below. A disassembly would verify
> this, but at least it gives you an idea of the inner workings.

It is in fact identical. Disassembly with the tools found on sourceforge
was fun, since they have endianness bugs, don't recognise the 'JMP'
which was the first instruction, and need each 3-byte instruction in the
binary to be prefixed with a zero byte to make it 4 bytes. But after
sorting that out and going through it instruction by instruction, it
really does seem to match. Thanks very much for digging it out.

When you say 'GPL like the driver it came from', actually the driver
doesn't specify any version of the GPL but does refer to the top-level
COPYING file. So we'll take that to mean 'GPLv2 and not later', like the
majority of the kernel. OK?

-- 
dwmw2

