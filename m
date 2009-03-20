Return-Path: <linux-kernel-owner+w=401wt.eu-S1760183AbZCTS5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760183AbZCTS5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 14:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756344AbZCTS4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 14:56:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56180 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760208AbZCTS4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 14:56:50 -0400
Date: Fri, 20 Mar 2009 19:56:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Nitin Gupta <ngupta@vflare.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3]: compressed RAM block device
Message-ID: <20090320185637.GA1418@ucw.cz>
References: <49BF8ABC.6040805@vflare.org> <49BF8B4E.1030603@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49BF8B4E.1030603@vflare.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-03-17 17:06:46, Nitin Gupta wrote:
>  drivers/block/Kconfig     |   22 +
>  drivers/block/Makefile    |    1 +
>  drivers/block/compcache.c |  995 +++++++++++++++++++++++++++++++++++++++++++++
>  drivers/block/compcache.h |  160 ++++++++
>  4 files changed, 1178 insertions(+), 0 deletions(-)
>
> Creates RAM based block device (ramzswap0) which can be used as swap device.
> Pages swapped to this are compressed and stored in memory itself.
>
> The module is called compcache.ko. It depends on:
>  - xvmalloc.ko: memory allocator
>  - lzo_compress.ko
>  - lzo_decompress.ko
>
> See Documentation/blockdev/compcache.txt for usage details.
>
> Project home: http://code.google.com/p/compcache/


Compcache is really bad name for this. zramdisk? gzrd?

Is the block device useful for general filesystem storage?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
