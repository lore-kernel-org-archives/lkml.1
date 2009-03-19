Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbZCSQDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbZCSQDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 12:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754451AbZCSQDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 12:03:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:39717 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbZCSQDL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 12:03:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sSc+SHyCw0YurfcFgnE56+JJnFAZ1Y5tmpvH/b5qGCOyljTWn3okv4P2feRfJuAfzY
         Tm4uXcy/zV/6cE1x+zlkjAV7qf1biMr5DEHdQ4RrFz58LM8Da/BFjmBNELo0Jp36R74l
         rQBWdkY9YAh93LblwZ63LzaUXgyK9p3bM+Lpw=
MIME-Version: 1.0
In-Reply-To: <20090319040809.GA29249@kroah.com>
References: <20090319040809.GA29249@kroah.com>
Date: Thu, 19 Mar 2009 12:03:09 -0400
Message-ID: <6c046ab30903190903r298a0334n939e64403b8aeda6@mail.gmail.com>
Subject: Re: [patch 0/5] Intel Poulsbo/Morrestown DRM driver and DRM core 
	changes
From: Sindhudweep Sarkar <sindhudweep.sarkar@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
       Richard Purdie <rpurdie@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This might be the opinion of a completely non educated end user but it
seems that an intel specific drm and other bits (xorg, mesa) would be
somewhat of a maintenance waste.

TI-OMAP 3xxx and a couple of other arm processors use similar SGX-5xx
graphics cores. IIRC arm is often little endian so perhaps a unified
driver would be easier in the long term.

On Thu, Mar 19, 2009 at 12:08 AM, Greg KH <greg@kroah.com> wrote:
> Hi,
>
> Here's 5 patches that add the Intel Poulsbo/Morrestown DRM driver to the
> kernel tree.
>
> There are 4 patches that make changes to the DRM core, and one patch
> that adds the DRM driver itself.  The driver is added to the
> drivers/staging/ directory because it is not the "final" driver that
> Intel wishes to support over time.  The userspace api is going to
> change, and work is currently underway to hook up properly with the
> memory management system.
>
> However this work is going to take a while, and in the meantime, users
> want to run Linux on this kind of hardware.  I'd really like to add the
> driver to the staging tree, but it needs these core DRM changes in order
> to get it to work properly.
>
> Originally I had a patch that basically duplicated the existing DRM
> core, and embedded it with these changes and the PSB driver together
> into one big mess of a kernel module.  But Richard convinced me that
> this wasn't the "nicest" thing to do, and he did work on the PSB code
> and dug out these older DRM patches.
>
> The only thing that looks a bit "odd" to me is the unlocked ioctl patch,
> Thomas, is that thing really correct?
>
> David, I'd be glad to take the DRM changes through the staging tree, but
> only if you ack them.
>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
