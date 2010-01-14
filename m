Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174Ab0ANV0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab0ANV0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 16:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903Ab0ANVZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 16:25:59 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:48332 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab0ANVZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 16:25:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UGHEIIXdFzZHTLeXyh5wjCVo8cn8G0tggf66iPXHnKi4Vq767Un2KCd2dx2VH/V6wM
         B6xGAs/F4FghdKu1/Lshv9ZQ7PAksLLZtYT4/mUdWj2RJQ5ARpHC31gM/ortbX1gQe72
         BfAiL5hp9eCbILueM/YX0gEfa9gL6FBiKUdTo=
MIME-Version: 1.0
In-Reply-To: <20100114124802.025bbcae@jbarnes-piketon>
References: <alpine.LFD.2.00.1001122139411.17145@localhost.localdomain>
	 <84144f021001131303u56fa5470ua1c27dfef9f3de81@mail.gmail.com>
	 <20100113133357.67f9df6d@jbarnes-piketon>
	 <4B4E403C.1050509@cs.helsinki.fi>
	 <20100113165530.2a7e7645@jbarnes-piketon>
	 <4B4F6D5F.10008@cs.helsinki.fi>
	 <20100114193118.GA1203@emergent.ellipticsemi.com>
	 <84144f021001141218pa3cd71co76165532618145a8@mail.gmail.com>
	 <20100114202803.GA1749@emergent.ellipticsemi.com>
	 <20100114124802.025bbcae@jbarnes-piketon>
Date: Thu, 14 Jan 2010 23:25:57 +0200
X-Google-Sender-Auth: d06efd923fd3fbed
Message-ID: <84144f021001141325o4b54b5fdj84ee5d39fd8ddff3@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: disable LVDS downclock by default
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Nick Bowler <nbowler@elliptictech.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       airlied@linux.ie, eric@anholt.net, intel-gfx@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse,

On Thu, Jan 14, 2010 at 10:48 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> Many platform support this feature, and it can provide significant
> power savings when the reduced refresh rate is low.  However, on some
> platforms a secondary (reduced) timing is provided but not actually
> supported by the hardware.  This results in undesirable flicker at
> runtime.
>
> So disable the feature by default, but allow users to opt-in to the
> reduced clock behavior with a new module parameter, lvds_downclock,
> that can be set to 1 to enable the feature.
>
> Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>
> --
>
> Nick and Pekka, please try this out and reply with your Tested-by
> (assuming it works, if not I'll fix it up).

This gives me pretty much identical results as your original patch.
That is, the "shakes" are gone but I still see the occasional "flash".
Should I give Nick's patch a try to see if we're looking at the same
issue or wait for your new patch?

                        Pekka
