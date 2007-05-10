Return-Path: <linux-kernel-owner+w=401wt.eu-S1760748AbXEJOdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760748AbXEJOdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 10:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbXEJOdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 10:33:15 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:48201 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbXEJOdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 10:33:15 -0400
Date: Thu, 10 May 2007 16:30:15 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Richard Purdie <richard@openedhand.com>,
       LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Add LZO1X compression support to the kernel
In-Reply-To: <20070509232129.371f49d5.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.61.0705101627580.24536@yvahk01.tjqt.qr>
References: <1178096183.5860.25.camel@localhost.localdomain>
 <20070509232129.371f49d5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 9 2007 23:21, Andrew Morton wrote:
>On Wed, 02 May 2007 09:56:23 +0100 Richard Purdie <richard@openedhand.com> wrote:
>
>> Add LZO1X compression/decompression support to the kernel.
>> 
>> This is based on the standard userspace lzo library, particularly
>> minilzo with the headers much trimmed down and simplified for kernel
>> use. Its structured so that it should still diff with the userspace
>> version for ease of future updating.
>
>Well that's attractive-looking code.
>Why is this needed?  What code plans to use it?

Perhaps squashfs [not included] could use it as an alternative to
zlib or LZMA* [not included either].

* That's floating patches not in the official squashfs AFAICT.


	Jan
-- 
