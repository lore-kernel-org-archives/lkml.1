Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050Ab0A1ByX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab0A1ByX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 20:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756005Ab0A1ByV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 20:54:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55613 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab0A1ByV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 20:54:21 -0500
Message-ID: <4B60EE44.7080508@infradead.org>
Date: Wed, 27 Jan 2010 23:54:12 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: linux-next: v4l-dvb tree build failure
References: <20100127175917.5d690f52.sfr@canb.auug.org.au> <1264634688.3088.1.camel@palomino.walls.org>
In-Reply-To: <1264634688.3088.1.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Walls wrote:
> On Wed, 2010-01-27 at 17:59 +1100, Stephen Rothwell wrote:
>> Hi Mauro,
>>
>> Today's linux-next build (powerpc allyesconfig) failed like this:
>>
>> drivers/media/video/cx18/cx18-alsa-pcm.c: In function 'snd_pcm_alloc_vmalloc_buffer':
>> drivers/media/video/cx18/cx18-alsa-pcm.c:234: error: implicit declaration of function 'vfree'
>> drivers/media/video/cx18/cx18-alsa-pcm.c:236: error: implicit declaration of function 'vmalloc'
>>
>> Caused by commit 5e9a302853301e0a2bb6671036daac3366fd85f4 ("V4L/DVB: cx18: overhaul ALSA PCM device handling so it works").
>>
>> I applied the following patch for today.
>>
>> From: Stephen Rothwell <sfr@canb.auug.org.au>
>> Date: Wed, 27 Jan 2010 17:53:39 +1100
>> Subject: [PATCH] V4L/DVB: using vmalloc requires include of linux/vmalloc.h
>>
>> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> 
> Stephen,
> 
> Looks good to me.
> 
> Acked-by: Andy Walls <awalls@radix.net>

Added at the tree.

Cheers,
Mauro.
