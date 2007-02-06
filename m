Return-Path: <linux-kernel-owner+w=401wt.eu-S1750863AbXBFGfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750863AbXBFGfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 01:35:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbXBFGfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 01:35:01 -0500
Received: from terminus.zytor.com ([192.83.249.54]:38725 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbXBFGfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 01:35:01 -0500
Message-ID: <45C820EF.3030502@zytor.com>
Date: Mon, 05 Feb 2007 22:32:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@verizon.net>
CC: linux-kernel@vger.kernel.org, Jesper Juhl <jesper.juhl@gmail.com>,
       Andi Kleen <ak@suse.de>, Trent Waddington <trent.waddington@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][5/5] floppy.c: Fix device_create_file() warning
References: <200702060030.33671.jesper.juhl@gmail.com> <200702060059.18345.gene.heskett@verizon.net>
In-Reply-To: <200702060059.18345.gene.heskett@verizon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> On Monday 05 February 2007 18:30, Jesper Juhl wrote:
> 
> And this is almost OT for this, but I'd like to interject here that in 
> recent history, it has been very very difficult to properly access LSN0 
> of a floppy.  Some formats, such as those laid down by a WD-1773 floppy 
> controller, do indeed use a sector marking of '0' (zero) on all tracks.
> 

I thought the sector numbers of floppy discs were software programmable 
(at formatting time.)  I believe different OSes used different offsets, 
with 1, 2, 3... being the way IBM did it in the PC, but all kinds of 
variants were used, including things like 0xa0, 0xa1, ... for no 
apparent reason.

	-hpa
