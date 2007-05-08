Return-Path: <linux-kernel-owner+w=401wt.eu-S934766AbXEHIs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934766AbXEHIs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 04:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934732AbXEHIsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 04:48:55 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:4947 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934710AbXEHIsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 04:48:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=S3D+W2J4lJ4TGCK4ZUVN5wz65+Nygw/nSn2Sce/OlN/vO3xmqJ0EcDt90Ka0oTkam7JR0FjijPawOzOysDAu1AW3eCt+UkcJJRV+u/DSEOlPu5cJ2DYD7ISdVUeWGVD/rYkrS1AbTVLq3RZenQVxGiQve3XeBg0jPBYxjZ1yJq8=
Message-ID: <f19298770705080148u70638ac2ue87241382681088@mail.gmail.com>
Date: Tue, 8 May 2007 12:48:51 +0400
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Tomasz Chmielewski" <mangoo@wpkg.org>
Subject: Re: [PATCH] Intel IXP4xx network drivers v.2 - Ethernet and HSS
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       netdev@vger.kernel.org, "Michael Jones" <mlj28@cam.ac.uk>,
       "Krzysztof Halasa" <khc@pm.waw.pl>
In-Reply-To: <464034CF.20700@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464034CF.20700@wpkg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/07, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> Michael Jones wrote:
>
> >> +#ifndef __ARMEB__
> >> +#warning Little endian mode not supported
> >> +#endif
> >
> > Personally I'm less fussed about WAN / LE support. Anyone with any
> > sense will run ixp4xx boards doing such a specialised network
> > operation as BE. Also, NSLU2-Linux can't test this functionality with
> > our LE setup as we don't have this hardware on-board. You may just
> > want to declare a depends on ARMEB in Kconfig (with or without OR
> > (ARM || BROKEN) ) and have done with it - it's up to you.
>
> Christian Hohnstaedt's work did support LE though.
>
> Not all ixp4xx boards are by definition "doing such a specialised
> network operation".
>

I was always curious, why do people want to run ixp4xx in LE mode? What
are the benefits that overweight the obvious performance degradation?
