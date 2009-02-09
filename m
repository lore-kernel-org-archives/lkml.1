Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbZBIQsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbZBIQsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 11:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755967AbZBIQs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 11:48:27 -0500
Received: from h155.mvista.com ([63.81.120.155]:16864 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755959AbZBIQsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 11:48:25 -0500
Message-ID: <49905E70.8000209@ru.mvista.com>
Date: Mon, 09 Feb 2009 19:48:48 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Hugh Dickins <hugh@veritas.com>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, rjw@sisk.pl
Subject: Re: [PATCH] libata-sff: fix 32-bit PIO regression
References: <200902082253.07438.sshtylyov@ru.mvista.com> <Pine.LNX.4.64.0902082108290.18661@blonde.anvils> <498F73A5.2070300@ru.mvista.com> <Pine.LNX.4.64.0902091016520.14410@blonde.anvils> <49905D08.4050302@ru.mvista.com>
In-Reply-To: <49905D08.4050302@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>>>> Yes, looks nice, and works for me.  My only criticism would be,
>>>> minor issue unchanged by your patch, that actually "slop" isn't
>>>> unlikely enough to deserve an "unlikely" - slop of 1 or 3 is
>>>> unlikely, but slop of 2 is quite common.

>>> Common on what types of ATAPI commands? I can hardly believe that 
>>> they are
>>> common on the block I/O...

>> When I checked (mounting and listing a CD), about 34% of
>> commands had slop 2.

>    Hm, that probably involved the raw block reads. I don't remember the 
> raw sector length off-hand but it may well be just even, not divisble by 4.

    Oops, I read "listening" instead of "listing". :-/
    But I thought that listing shouldn't involve anything other than block 
reads. OTOH, I'm not familiar enough with ISO9660... What commands are you 
seeing (if you have them dumped)?

>> But you're right, now I try copying
>> a large file, there's no slop involved in that at all.


>> Hugh

MBR, Sergei
