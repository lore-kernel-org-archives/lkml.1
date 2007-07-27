Return-Path: <linux-kernel-owner+w=401wt.eu-S936905AbXG0Trn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936905AbXG0Trn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 15:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934539AbXG0Tra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 15:47:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:5359 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964807AbXG0TrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 15:47:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R/8kXS7+Qss5I9bHNbBPRMq3kbYUiSYpvlmjasE2VFUYK/GII0jim5NtkUM/bGgww3mKx+VGGk7ZdGvu3u+3J6C/Dok4pxcWi3E4LG87IU/k4NFZPdGSn2qwN5e2SDA7NgI0F/VWaI8EHrgqw3dFMzvwC1wdOESHzlMeded3A/k=
Message-ID: <92a12cdb0707271247s727993b8i33999a9652b2ca20@mail.gmail.com>
Date: Fri, 27 Jul 2007 20:47:21 +0100
From: "Adrian McMenamin" <adrianmcmenamin@gmail.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: Problems with framebuffer in 2.6.22-git17
Cc: "Adrian McMenamin" <lkmladrian@gmail.com>, linux-kernel@vger.kernel.org,
       lethal@users.sourceforge.net
In-Reply-To: <1185406433.5046.23.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <92a12cdb0707221141i4398d6fdxa7994c5f1f809b0a@mail.gmail.com>
	 <1185146563.6370.8.camel@daplas>
	 <8b67d60707241445l2764d9f1odb72848342135048@mail.gmail.com>
	 <1185406433.5046.23.camel@daplas>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/07/07, Antonino A. Daplas <adaplas@gmail.com> wrote:

>
> I'm also confused. Can you change the color depth to 32 bpp ('fbset
> -depth 32')?  I'm thinking of a possible pseudo_palette overrun.
>

The code behaves in exactly the same way with the bit depth set to 32
and without the patch reversion (ie forces a reboot).

With the parch reverted there is a flicker of output on the screen
before a reboot is forced (it will boot with 16bpp though the colour
is a bit iffy)

With the patch reverted and 24bpp, it oopses before freezing (with two
odd looking boot logos on the screen):

[    1.485628] Console: switching to colour frame buffer device 80x30
[    1.553925] Unable to handle kernel paging request at virtual
address 55ff5504
[    1.562351] pc = 8c0033a0
[    1.565402] Unable to handle kernel paging request at virtual
address 0c1e8688
[    1.573784] pc = 8c00b9e2
[    1.576833] Unable to handle kernel paging request at virtual
address 0c1e81ec
[    1.585205] pc = 8c00b9e2
[    1.588258] Unable to handle kernel paging request at virtual
address 0c1e81ec
[    1.596641] pc = 8c00b9e2
[    1.599688] Unable to handle kernel paging request at virtual
address 0c1e81ec
[    1.608069] pc = 8c00b9e2
[    1.611117] Unable to handle kernel paging request at virtual
address 0c1e81ec
[    1.619488] pc = 8c00b9e2
[    1.622549] Unable to handle kernel paging request at virtual
address 0c1e81ec
[    1.630927] pc = 8c00b9e2
[    1.633979] Unable to handle kernel paging request at virtual
address 0c1e81ec
[    1.642370] pc = 8c00b9e2
[    1.645421] Unable to handle kernel paging request at virtual
address 0c1e81ec
[    1.653793] pc = 8c00b9e2
[    1.656854] Unable to handle kernel paging request at virtual
address 0c1e81ec
[    1.665226] pc = 8c00b9e2
[    1.668273] Unable to handle kernel paging request at virtual
address 0c1e81ec
[    1.676664] pc = 8c00b9e2
[    1.679715] Unable to handle kernel paging request at virtual
address 0c1e81ec
[    1.688086] pc = 8c00b9e2
[    1.691191] Unable to handle kernel paging request at virtual
address 0c1e81ec
[    1.699557] pc = 8c00b9e2
[    1.702603] Unable to handle kernel paging request at virtual
address 0c1e81ec
[    1.710988] pc = 8c00b9e2
[    1.714036] Unable to handle kernel paging request at virtual
address 0c1e81ec
[    1.722408] pc = 8c00b9e2
[    1.725468] Unable to handle kernel paging request at virtual
address 0c1e81ec
[    1.733837] pc = 8c00b9e2
[    1.736884] Unable to handle kernel paging request at virtual
address 0c1e81ec
[    1.745270] pc = 8c00b9e2
[    1.748314] Unable to handle kernel paging request at virtual
address 0c1e81ec
[    1.756696] pc = 8c00b9e2
[    1.759745] Unable to handle kernel paging request at virtual
address 0c1e81ec
[    1.768111] pc = 8c00b9e2
[    1.771155] Unable to handle kernel paging request at virtual
address 0c1e81ec
[    1.779538] pc = 8c00b9e2
[    1.782584] Unable to handle kernel paging request at virtual
address 0c1e81ec
[    1.790997] pc = 8c00b9e2
[    1.794045] Unable to handle kernel paging request at virtual
address 0c1e81ec
[    1.802452] pc = 8c00b9e2
[    1.805500] Unable to handle kernel paging request at virtual
address 0c1e81ec
[    1.813888] pc = 8c00b9e2
[    1.816937] Unable to handle kernel paging request at virtual
address 0c1e81ec
[    1.825326] pc = 8c00b9e2
[    1.828378] Unable to handle kernel paging request at virtual
address 0c1e81ec
[    1.836753] pc = 8c00b9e2
[    1.839846] Unable to handle kernel paging request at virtual
address 0c1e81ec
[    1.848215] pc = 8c00b9e2
[    1.851263] Unable to handle kernel paging request at virtual
address 0c1e81ec
[    1.859649] pc = 8c00b9e2
[    1.862695] Unable to handle kernel paging request at virtual
address 0c1e81ec
[    1.871066] pc = 8c00b9e2


In short all versions of the driver seem to be broken in some way, but
it won't boot at all unless the patch is reverted
