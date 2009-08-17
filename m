Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbZHQOZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbZHQOZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 10:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754366AbZHQOZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 10:25:21 -0400
Received: from lucidpixels.com ([75.144.35.66]:51861 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251AbZHQOZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 10:25:21 -0400
Date: Mon, 17 Aug 2009 10:25:22 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Christoph Hellwig <hch@infradead.org>
cc: Felix Blyakher <felixb@sgi.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: Kernel 2.6.30.4 XFS(..?) regression (happened again)
In-Reply-To: <20090816022331.GA2309@infradead.org>
Message-ID: <alpine.DEB.2.00.0908171024380.12533@p34.internal.lan>
References: <alpine.DEB.2.00.0908080422440.12329@p34.internal.lan> <00980BBF-1206-4BEF-A8AE-B4A8DAE7EC27@sgi.com> <alpine.DEB.2.00.0908090605080.16485@p34.internal.lan> <alpine.DEB.2.00.0908110624420.22426@p34.internal.lan>
 <20090816022331.GA2309@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 15 Aug 2009, Christoph Hellwig wrote:

> All your traces seem to have in common that you're block on locks hold
> by processed doing I/O.  Especially a lot of page locks which are
> controlled by the VM and not the filesystem.  Can you try with commit
> 8aa7e847d834ed937a9ad37a0f2ad5b8584c1ab0 from 2.6.31-rc applied, or
> better directly 2.6.3-rc6?
>
> I would be surprised if this is something inside XFS, but running with
> CONFIG_XFS_DEBUG never hurts.
>

Christoph,

Thanks, running with DEBUG and 2.6.31-rc6.

CONFIG_XFS_DEBUG=y

So far the problem has not surfaced, but it normally takes 24-48 hours.

Justin.
