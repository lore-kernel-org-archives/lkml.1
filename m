Return-Path: <linux-kernel-owner+w=401wt.eu-S1762966AbXKHU0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762966AbXKHU0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 15:26:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761348AbXKHUZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 15:25:55 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:14178 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761281AbXKHUZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 15:25:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JcoXCcQ+KsmH5/1KGlqmsJakJOAsKTNGDQ4TIVBsOXpv0mWgGfT23WkmYyJEq9T3HEo4fGqLkbXq6nk/L7ziK9QtxTRpvuvMNXOAl6Pkuu8q8zJA19sicMNqpEP+xaSqSlCq6raqJLQCGjn/aHxVICM26NQ6Atr1H+hKzbjRTbI=
Message-ID: <68676e00711081225n6230538w30bf38d359ddd447@mail.gmail.com>
Date: Thu, 8 Nov 2007 21:25:49 +0100
From: "Luca Tettamanti" <kronos.it@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: sata NCQ blacklist entry
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>
In-Reply-To: <4731B5DD.1060203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071107111813.GA9064@dudweiler.stuttgart.redhat.com>
	 <4731B5DD.1060203@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 7, 2007 1:55 PM, Tejun Heo <htejun@gmail.com> wrote:
> Florian La Roche wrote:
> > Hello all,
> >
> > I've taking email addresses from the last NCQ blacklist changes going
> > into the kernel.
> > This Fujitsu drive also gives me spurious command completions. Detailed
> > output also available at https://bugzilla.redhat.com/show_bug.cgi?id=366181.
> >
> > Let me know if you need more info or anything else.
> >
> > --- drivers/ata/libata-core.c
> > +++ drivers/ata/libata-core.c
> > @@ -4222,6 +4222,7 @@
> >       { "WDC WD740ADFD-00NLR1", NULL,         ATA_HORKAGE_NONCQ, },
> >       { "WDC WD3200AAJS-00RYA0", "12.01B01",  ATA_HORKAGE_NONCQ, },
> >       { "FUJITSU MHV2080BH",  "00840028",     ATA_HORKAGE_NONCQ, },
> > +     { "FUJITSU MHW2160BJ G2",       NULL,           ATA_HORKAGE_NONCQ },
> >       { "ST9120822AS",        "3.CLF",        ATA_HORKAGE_NONCQ, },
> >       { "ST9160821AS",        "3.CLF",        ATA_HORKAGE_NONCQ, },
> >       { "ST9160821AS",        "3.ALD",        ATA_HORKAGE_NONCQ, },
>
> Thanks.  We're currently trying to find out what's actually going on
> with all these drives.  At first, drives which got blacklisted aren't
> many and made sense (had other problems with NCQ, etc..) but with new
> generation drives from many vendors showing the same symptom, we aren't
> too sure now.

Is there a way to tell whether Windows is using NCQ or not? I checked
the system log (or whatever it's called) on my notebook and is clean
but I'm not sure it's using NCQ (I don't even know if it'd log
spurious completions somewhere).

Luca
