Return-Path: <linux-kernel-owner+w=401wt.eu-S1751001AbZLUFjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751001AbZLUFjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 00:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbZLUFjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 00:39:23 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:41749 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbZLUFjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 00:39:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TWh9n8pljxXZLjHehfN/Ro9a7lKZ57bbFf6f9rgxUmIXGllUuSpc4ifU0wEvr2TS+B
         kMbZw2sqt4zz3UcsdNs7woFISjo+V2XkYO9F2xMhjyK/zrwhPQPPBOvs/UjNaPkWK7pL
         4RHowklByK3nTfLVUGAAMsjoHlWH9f/2b+EZE=
MIME-Version: 1.0
In-Reply-To: <20091221012447.GA24782@basil.fritz.box>
References: <20091221012447.GA24782@basil.fritz.box>
Date: Mon, 21 Dec 2009 15:39:22 +1000
Message-ID: <21d7e9970912202139j1039a647oc43affa4be6990af@mail.gmail.com>
Subject: Re: [PATCH] DRM: Rename clamp variable
From: Dave Airlie <airlied@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 11:24 AM, Andi Kleen <andi@firstfloor.org> wrote:
> DRM: Rename clamp variable
>
> linux/kernel.h has a "clamp" macro, but r300_cmdbuf also uses a variable
> with the same name. Right now it doesn't seem to include the header,
> but sooner or later someone will. So better rename the variable
> now.
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Queued for drm-core-next, will push to Linus in next push.

Thanks,
Dave.
