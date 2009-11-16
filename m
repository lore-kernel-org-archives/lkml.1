Return-Path: <linux-kernel-owner+w=401wt.eu-S1752262AbZKPSFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbZKPSFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 13:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZKPSFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 13:05:49 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55354 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbZKPSFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 13:05:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KrIKvqxmRojv/l5MksRJ4DWi3zonQOKv+tW7O6Z9KuOs5IQ8pCtMMzrgJT0G2U1mbB
         uEFeuCpTF7n9ZyKqx7MmSwaciQnJ6Ly0cJ7WAxZZ9izcRiJM3Oj5fDEgB8IUibmMmfyk
         v0PEOTq4EtDYe0AYrl06Gr8pVbU4tUHeJj+nM=
Subject: Re: [PATCH v2] ALPS: Add support for 4 directions button on Acer
 Aspire 5720
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@suse.cz>
In-Reply-To: <20091115085314.GB9844@core.coreip.homeip.net>
References: <1256955018.9681.23.camel@maxim-laptop>
	 <1257846940.4921.11.camel@maxim-laptop>
	 <1257847427.4921.13.camel@maxim-laptop>
	 <20091110173047.GC15263@core.coreip.homeip.net>
	 <1257930590.3601.2.camel@maxim-laptop>
	 <20091115085314.GB9844@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Nov 2009 20:05:48 +0200
Message-ID: <1258394748.4134.2.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-15 at 00:53 -0800, Dmitry Torokhov wrote: 
> Hi Maxim,
> 
> On Wed, Nov 11, 2009 at 11:09:50AM +0200, Maxim Levitsky wrote:
> > >From 6b263982ffd62ae4621a5202f0084983af8dc093 Mon Sep 17 00:00:00 2001
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Date: Wed, 11 Nov 2009 11:03:35 +0200
> > Subject: [PATCH] ALPS: Add support for 4 directions button on Acer Aspire 5720
> >  Implemented using DMI due to uncertainty about systems that have
> >  only the middle button
> > 
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> 
> I don't think that we need to do DMI checking. I looked through my mails
> and it looks like all Acers with that signature have 4-directional
> button while Volstro 1400 only has left and right button and so won't be
> affected. Also Synaptics driver treats BTN_0 as BTN_FORWARD and BTN_1
> as BTN_BACK by default so we should still be compatible.
> 
> Could you please try the patch below? It assumes that psmosue core does
> not set up BTN_MIDDLE capability ahead of time though (see a patch
> posted earlier today).
> 
> -- 
> Dmitry
> 
> Input: ALPS - add support for 4 directions button on Acer Aspire 5720
> 
> From: Maxim Levitsky <maximlevitsky@gmail.com>
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---

Works just fine!

Best regards,
Maxim Levitsky

