Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbYHFQWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbYHFQWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 12:22:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757175AbYHFQUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 12:20:46 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:3331 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756890AbYHFQUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 12:20:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=PhF+as9kGNdWUjn8QLLLfjVPcOCfAmremZ6yzag/GvmoyBOMS/2iFnR1M4hQ0wCgZ6
         XHKWrs/Twp7FEGjObOd1Ge5JO5RYOb1tHS4+vpcA/L/Z8pigGdFW6MmceQNHW5x6BHwy
         xH3gTFXCKsBR4nfy6QsBBvFLyAHFIK+ZKz/y8=
Message-ID: <6a89f9d50808060920t168d533g5d440b444e7c09fc@mail.gmail.com>
Date: Wed, 6 Aug 2008 18:20:40 +0200
From: "Stephane Marchesin" <marchesin@icps.u-strasbg.fr>
To: "Keith Packard" <keithp@keithp.com>
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
Cc: "John Stoffel" <john@stoffel.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Eric Anholt" <eric@anholt.net>, linux-kernel@vger.kernel.org
In-Reply-To: <1217910505.24714.152.camel@koto.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	 <200808042043.46710.nickpiggin@yahoo.com.au>
	 <1217850352.24714.66.camel@koto.keithp.com>
	 <Pine.LNX.4.64.0808041720500.25617@blonde.site>
	 <1217870748.24714.79.camel@koto.keithp.com>
	 <Pine.LNX.4.64.0808041855050.5717@blonde.site>
	 <1217877645.24714.87.camel@koto.keithp.com>
	 <Pine.LNX.4.64.0808042055240.17041@blonde.site>
	 <18583.47633.987143.236236@stoffel.org>
	 <1217910505.24714.152.camel@koto.keithp.com>
X-Google-Sender-Auth: 588cf83e7b32d7cc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/5/08, Keith Packard <keithp@keithp.com> wrote:
> On Mon, 2008-08-04 at 22:25 -0400, John Stoffel wrote:
>
>  > What about the onboard memory of graphics cards?  Isn't that where
>  > Textures and such are stored as well?  So once something is loaded to
>  > the card, shouldn't you be able to free it in system memory?  Or swap
>  > it out ahead of time?
>
>
> Right now, I'm working only on Intel integrated graphics, which doesn't
>  have any on-board memory. My thinking is that we'd best solve the
>  easiest case first before attempting the harder discrete graphics
>  driver. Plus, Intel pays me do do integrated graphics, so I have an
>  incentive.
>

Right, but it sounds adventurous to merge this work upstream before it
is generic enough to work on discrete cards. Right now it only works
on intel integrated cards ; integrated cards are one business,
discrete are a completely different world and the issues afoot
completely different.

Should this go upstream, the kernel guys have to keep in mind and
accept the possibility that another memory manager might be needed at
some point.

Stephane
