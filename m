Return-Path: <linux-kernel-owner+w=401wt.eu-S1752112Ab0AZUhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab0AZUhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 15:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761Ab0AZUhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 15:37:42 -0500
Received: from mail.crca.org.au ([67.207.131.56]:46993 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669Ab0AZUhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 15:37:42 -0500
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4B5F52FE.5000201@crca.org.au>
Date: Wed, 27 Jan 2010 07:39:26 +1100
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Pedro Ribeiro <pedrib@gmail.com>
CC: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       "linux-mm@kvack.org >> linux-mm" <linux-mm@kvack.org>
Subject: Re: BUG at mm/slab.c:2990 with 2.6.33-rc5-tuxonice
References: <74fd948d1001261121r7e6d03a4i75ce40705abed4e0@mail.gmail.com>
In-Reply-To: <74fd948d1001261121r7e6d03a4i75ce40705abed4e0@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Pedro Ribeiro wrote:
> Hi,
> 
> I hit a bug at mm/slab.c:2990 with .33-rc5.
> Unfortunately nothing more is available than a screen picture with a
> crash dump, although it is a good one.
> The bug was hit almost at the end of a hibernation cycle with
> Tux-on-Ice, while saving memory contents to an encrypted swap
> partition.
> 
> The image is here http://img264.imageshack.us/img264/9634/mmslab.jpg (150 kb)
> 
> Hopefully it is of any use for you. Please let me know if you need any
> more info.

Looks to me to be completely unrelated to TuxOnIce - at least at a first
glance.

Ccing the slab allocator maintainers listed in MAINTAINERS.

Regards,

Nigel
