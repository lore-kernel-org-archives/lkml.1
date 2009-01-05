Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbZAEUgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbZAEUgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 15:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbZAEUgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 15:36:39 -0500
Received: from fhw-relay07.plus.net ([212.159.14.148]:57205 "EHLO
	fhw-relay07.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbZAEUgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 15:36:38 -0500
Message-ID: <49626F4C.80600@yahoo.com>
Date: Mon, 05 Jan 2009 20:36:28 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Pavel Machek <pavel@suse.cz>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
References: <fa.P4z5CJpM0xT37PWJuOuCHDkO76o@ifi.uio.no> <fa.26o5IHCAC3TQdXupl62CLYwQ+Wk@ifi.uio.no> <fa.GBkQuKdRj+YRVczlNLFhGvaw3WY@ifi.uio.no> <fa.rCyCghh/+staAmYi/+gwYvefIS0@ifi.uio.no> <fa.c5j7jAMUnJPvgI9Oj/VczSDNakE@ifi.uio.no> <fa.377DMq2lPMyaHxadPnApFSJFoCg@ifi.uio.no>
In-Reply-To: <fa.377DMq2lPMyaHxadPnApFSJFoCg@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: 3cf3f9f47fbd665c0fbd1b82a10ea848
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> Don't forget non-cheasy mounting options so an accidental brush
> against the side of the unit doesn't cause the hard drive to become
> disconnected from system and suffer a power drop.  I guess that gets
> filed under "Brute force" as well.  :-)

Are you thinking of sync? If so I have experience of this not helping 
with ext3 on an 8Gbyte SD card in an EeePC 900. Sooner or later a bunch 
of zeros overwrites the early part of the partition and an fsck tears 
the FS apart. This seems to happen quickly if you are booting your root 
from the SD card (no swap though). A FAT32 partition seems to be 
unperturbed so far (but it's not being used the same way as the ext3 
partition).

> P.S.  I feel obliged to point out that in my Lenovo X61s, the SD card
> is flush with the laptop case when inserted, and I've never had a
> problem with the SD card prematurely ejected during operaiton.   :-)

I have never had premature ejection of SD with my Eee...
