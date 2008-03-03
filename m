Return-Path: <linux-kernel-owner+w=401wt.eu-S1757020AbYCCOCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020AbYCCOCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 09:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbYCCOCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 09:02:41 -0500
Received: from lazybastard.de ([212.112.238.170]:55568 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbYCCOCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 09:02:40 -0500
Date: Mon, 3 Mar 2008 15:01:56 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, dwmw2@infradead.org,
       linux-sh <linux-sh@vger.kernel.org>
Subject: Re: MTD types
Message-ID: <20080303140155.GA17732@lazybastard.org>
References: <8b67d60803021219k23ca6c6bt2ce2fb2c61cda42e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8b67d60803021219k23ca6c6bt2ce2fb2c61cda42e@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 March 2008 20:19:09 +0000, Adrian McMenamin wrote:
> 
> I am loathe to just post a patch adding it back, so does it make any
> difference if I use another type (I really have no idea of what the
> physical type used in the Dreamcast is, though possibly someone here
> might?)

There is also a bit of confusion about what any specific time should
_mean_.  Once upon a time NAND flash had ECC, could be written only once
(i.e. not write single bits by cleverly masking and rewriting), had a
well-known amount of OOB for general use, etc. while NOR could be
written bit-by-bit, rewritten, did not have ECC, had a higher quality
and all that.

These days you can buy NOR flashes that have all attributes of NAND
except OOB, NAND flashes may use all OOB area for error correction, etc.
etc.  In short, there is just about nothing left you can use the type
for.  And when it is used in JFFS2, you will find lots of code like "if
it is this type, but not that exception, then...".

Jörn

-- 
"Translations are and will always be problematic. They inflict violence
upon two languages." (translation from German)
