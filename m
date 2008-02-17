Return-Path: <linux-kernel-owner+w=401wt.eu-S1757974AbYBQKiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974AbYBQKiA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 05:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755104AbYBQKhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 05:37:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:27036 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108AbYBQKhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 05:37:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=mk2vz88bhQPZmBUoGB/vp/qgO+rOlMXux3UdMpWzrwEMfijAHoFN0CoDCxqsJgDB6bWuDcq8+1FnvS1AJOILnmiAQVsNo1ssUYGVoCnu+x5/6iEVajeCQfcaUuZ/Ha8D38MCPzt+i1gTZD+0S+rksMzU5irmw1BZU/iLgB9ssuQ=
Date: Sun, 17 Feb 2008 13:37:38 +0300
To: Nicholas Marquez <nicholas.marquez@gatech.edu>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] More accessible usage of custom flags
Message-ID: <20080217103738.GB6596@martell.zuzino.mipt.ru>
References: <e367bd3e0802161852v1265f101h86326b16362dd860@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e367bd3e0802161852v1265f101h86326b16362dd860@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 09:52:51PM -0500, Nicholas Marquez wrote:
> I submitted this patch to the zen-sources Gentoo community and got
> much praise and has promptly been included.  This kind of thing have
> very likely already been done in other patchsets, but I haven't seen
> it around,

Probably it wasn't done by other patchsets. ;-)

> so I've gone ahead and made one.  The idea is that one can
> enable -Os and various other options transparently through standard
> kernel configuration, so why bar the builder from any other options to
> pass on to gcc (et al)?

Examples, please. Which compiler flags do you want to add to your .config?
Speaking of -Os, it's CONFIG_CC_OPTIMIZE_FOR_SIZE .

> One can indeed add one's own flags in the
> Makefile, but this method is a good deal friendlier.  Granted, this
> could be misused by ricers and idiots, but they'll get themselves into
> that mess all of their own fault and we'll all go on our merry ways.

No, they will come here and report bugs they created themselves. And
there will be a policy: "too long CONFIG_CUSTOM_CFLAGS -- go away" and
so on.

> It just seems that much use could be made out of this, both in terms
> of (sane) optimizations

Sane optimizations should be added to main Makefile. 

> and easier access to enhanced debugging
> opportunities.

Which ones exactly?

> I see that people who build a Linux kernel are largely of two types:
> ~the ones that understand and know enough that they could, with some
> nudging and learning, become bonafide kernel devs and
> ~the ones that understand it to some very basic degree and can get
> through configuring it without too much trouble (though with limited
> understanding)
> I believe one of the very simple things that can be addressed is to
> make the kernel more "accessible" without harming its integrity or
> functionality.  This involves trying to fill the gap between those two
> types of people, allowing there to be more understanding,
> configuration, and (down the line) development opportunities within
> the kernel to better ease these people into learning enough to begin
> contributing back.

> More developers can only be a Good Thing (tm).

In general, wrong.
