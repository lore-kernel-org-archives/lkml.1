Return-Path: <linux-kernel-owner+w=401wt.eu-S1758428AbZBLL1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428AbZBLL1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 06:27:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758576AbZBLL0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 06:26:53 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:17223 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756743AbZBLL0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 06:26:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JT2JOvjxC4kSZ1nbYW8WFa+6ejFwMtwHmnDLtspDt1uBguxkb6+KGk9GXAn5JMdBiB
         18xOALHP502c08FGU0SDOyxae8FGs1+7515tROh1M65Qg7KxbXD1K3FjehWQ9eMjNZev
         /3C//O2R3fs7Hy1TwqXKwxbbNbqRG1t6fZT4M=
MIME-Version: 1.0
In-Reply-To: <20090212.021522.217840575.davem@davemloft.net>
References: <20090212.021522.217840575.davem@davemloft.net>
Date: Thu, 12 Feb 2009 21:26:51 +1000
Message-ID: <21d7e9970902120326j2ce300d9x7df5a870c69a95f5@mail.gmail.com>
Subject: Re: [PATCH 0/5]: ATI/RADEON DRM bug fixes...
From: Dave Airlie <airlied@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: airlied@linux.ie, benh@kernel.crashing.org,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 8:15 PM, David Miller <davem@davemloft.net> wrote:
>
> David, this work is against your drm-next branch.
>
> Here are a collection of bug fixes for the Radeon DRM support.  Most
> of them have to do with trying to access kernel virtual addresses
> using DRM_READ32() and DRM_WRITE32().
>
> With these patches at least the writeback test works on sparc64 and
> the CP is able to process commands in the ring.  I'm now diagnosing
> some further problem that's preventing Xorg from functioning fully but
> I should be able to diagnose that soon.
>
> You'll probably love patch #4 in this series, and it probably explains
> all kinds of weird problems people run into with DRM on radeon cards.

Thanks Dave,

These all look great, the EMITED one has potential to regress
something by fixing it,
but I think it might actually make things better, I'll push all of
these to Linus asap as
they all fix real bugs. I've put them into my drm-fixes branch and I'll try and
re-review and get some testing tomorrow when I'm more awake.

Dave.

>
> Please apply, thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
