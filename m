Return-Path: <linux-kernel-owner+w=401wt.eu-S936027AbZAPRj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936027AbZAPRj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 12:39:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757174AbZAPRjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 12:39:11 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:46426 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760034AbZAPRjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 12:39:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rH0ODxB+le/+ikh/u/uXOjO26u2Lle+1Q13Of9E5dW8ZYGWFUYD2QQ5ucUV8SPJ8Np
         OTJvGoBqh7Axv9QrKWvUNjs8j24AFIIkjK8jlOXQEstGUqDos/xJ934ZhWtT5JmtTYqA
         sMbW1ulp2kY9lxHEUcf9o4/EkHq3z8nt6GRVQ=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0901161106100.4940@axis700.grange>
References: <Pine.LNX.4.64.0812261714290.4895@axis700.grange>
	 <e9c3a7c20901051143m37c0d7c0x5779475ddc7c5dc2@mail.gmail.com>
	 <Pine.LNX.4.64.0901161106100.4940@axis700.grange>
Date: Fri, 16 Jan 2009 10:39:08 -0700
X-Google-Sender-Auth: 34841cf7c082ff18
Message-ID: <e9c3a7c20901160939y6b3906fp41531730d4b752a@mail.gmail.com>
Subject: Re: [PATCH 0/4 v6] i.MX31: dmaengine and framebuffer drivers
From: Dan Williams <dan.j.williams@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, Sascha Hauer <s.hauer@pengutronix.de>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 3:09 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Ok, let's do it this way: Sascha has acked version 8 of patches 2 and 3.
> And there seems to be no active framebuffer maintainer ATM. So, maybe you
> could take patches 1-3 into your tree, so they are exposed to the public,
> people have easier access to them in case they want to test (I had several
> requests), and you update them in case you change async-tx API again:-) It
> would be good to try and push them in for 2.6.29 - these are new drivers,
> so, might still be possible to convince Andrew / Linus, if not, you could
> keep them in your tree (and in next) until 2.6.30, then we'd add platform
> bindings and the camera driver. What do you think?

It will be weird to see drivers/video/ in a dmaengine pull request, but:

1/ as you point out it appears to be a free-for-all in that directory,
so Sascha's ack seems to be all that is needed here.
2/ merging the driver without any in-tree users does not make much sense
3/ these are new drivers so the risk of causing a regression should be
close to zero especially since none of the existing dmaengine users
will pick up these private channels

Can you send me the series, off-list, in a .tar.gz with Sascha's ack
to make sure I am applying the latest.  I can not seem to find [PATCH
2/4 v8] in my inbox...

Thanks,
Dan
