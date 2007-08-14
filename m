Return-Path: <linux-kernel-owner+w=401wt.eu-S1761241AbXHNWNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761241AbXHNWNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935462AbXHNVvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:51:48 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:17737 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbXHNVvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:51:45 -0400
Message-ID: <246a89290708141451n742a0f0bv2e95114319252050@mail.gmail.com>
Date: Tue, 14 Aug 2007 14:51:38 -0700
From: "Nathan Laredo" <laredo@gnu.org>
To: "Joe Perches" <joe@perches.com>
Subject: Re: [PATCH] [463/2many] MAINTAINERS - STRADIS MPEG-2 DECODER DRIVER
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <1187065967.32555.19.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46bffc01.7c95Dz5xUUkjysHI%joe@perches.com>
	 <246a89290708132104h4145349ah4a4a56ef852a1bb3@mail.gmail.com>
	 <1187065967.32555.19.camel@localhost>
X-Google-Sender-Auth: 72d620e24dc24d42
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No, not all of them.  Just the ones that show my name at the top of
the source file.

cs8240.h, ibmmpeg2.h, saa7121.h, saa7146*.h, stradis.c

stradis.c includes all of the above .h files, so they weren't listed separately.

Additionally, it should probably be noted that I still use a 2.2
kernel with this device and haven't tested the 3rd party ports to 2.6
yet but I've never actually gotten a bug report yet from someone
claiming it isn't working (but I'm pretty confident it will crash).

Thanks,
- Nathan Laredo
laredo@gnu.org

On 8/13/07, Joe Perches <joe@perches.com> wrote:
> On Mon, 2007-08-13 at 21:04 -0700, Nathan Laredo wrote:
> > Well, technically speaking, there are multiple files to the stradis
> > driver, not just stradis.c.
>
> These files seem to be shared between drivers.
>
> the Kconfig file shows:
>
> obj-$(CONFIG_VIDEO_STRADIS) += stradis.o
>
> as the only STRADIS file.
>
> Are you the maintainer for other entries?
> Should I add these entries?
>
> drivers/media/video/cs8420.h
> drivers/media/video/ibmmpeg2.h
> drivers/media/video/saa5249.c
> drivers/media/video/saa7110.c
> drivers/media/video/saa7111.c
> drivers/media/video/saa7121.h
> drivers/media/video/saa7146*.h
> drivers/media/video/saa7185.h
> drivers/media/video/saa7196.h
> drivers/media/video/videodev.c
>
>
>
>
