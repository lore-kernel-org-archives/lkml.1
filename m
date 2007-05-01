Return-Path: <linux-kernel-owner+w=401wt.eu-S1423644AbXEAVKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423644AbXEAVKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423655AbXEAVKC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:10:02 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:28760 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423644AbXEAVKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:10:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CIPTjws6eFLVQ21thjfE54qklVTT5a+iWrmZAA9LpYDFW908TmsOUGRi11jqW9/LjFWtWw0Jb/f9PUeGyDc3+M8cqxfrisLO0uKWN92fjEvMp+OU+U+2nRDcXxGRnS++0a1Qu2MldyIPymHXnIAnfIVfvzkVLcugkYsJbIsAQFE=
Message-ID: <d120d5000705011409o46b82708rf2cbfe3390141545@mail.gmail.com>
Date: Tue, 1 May 2007 17:09:59 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Michael Schmitz" <schmitz@debian.org>,
       "Roman Zippel" <zippel@linux-m68k.org>
Subject: Re: [patch 04/33] m68k: Atari keyboard and mouse support.
In-Reply-To: <20070501205740.GC21080@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070501203234.252205858@mail.of.borg>
	 <20070501203330.172479999@mail.of.borg>
	 <20070501205740.GC21080@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/07, Christoph Hellwig <hch@infradead.org> wrote:
>
> > --- linux-m68k-2.6.21.orig/include/linux/input.h
> > +++ linux-m68k-2.6.21/include/linux/input.h
> > @@ -676,6 +676,7 @@ struct input_absinfo {
> >  #define BUS_I2C                      0x18
> >  #define BUS_HOST             0x19
> >  #define BUS_GSC                      0x1A
> > +#define BUS_ATARI            0x1B
>
> Is this really a separate bus?  Should't we have a BUS_ONBOARD or so instead?

BUS_HOST shoudl fit the bill.

-- 
Dmitry
