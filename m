Return-Path: <linux-kernel-owner+w=401wt.eu-S1757969AbYBLW1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbYBLW1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757506AbYBLW1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:27:33 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:48986 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757494AbYBLW1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:27:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=DxyHtknIJAJdJwdeYUBiVA07L73RHstuyImYv9d2jG4A8+tAEmG9ek3lZkCShfn1zuU5iom2fPYSOVK1RVizf2OT4YJT/9NTvd6NWgRlnEBVTZXoL+UJXDA8rafUgIkt2ZBV2AFFI5XRyMc70evWIlT0IlJ8xkRDnK5D3ToN+/4=
Message-ID: <e9c3a7c20802121427v2f3aed68h68bfc12bbce19d19@mail.gmail.com>
Date: Tue, 12 Feb 2008 15:27:29 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [RFC v3 5/7] dmaengine: Make DMA Engine menu visible for AVR32 users
Cc: "Olof Johansson" <olof@lixom.net>, linux-kernel@vger.kernel.org,
       "Shannon Nelson" <shannon.nelson@intel.com>,
       "David Brownell" <david-b@pacbell.net>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       "Pierre Ossman" <drzeus-list@drzeus.cx>
In-Reply-To: <20080212231330.79738c3a@siona>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1202834638-9009-1-git-send-email-hskinnemoen@atmel.com>
	 <1202834638-9009-2-git-send-email-hskinnemoen@atmel.com>
	 <1202834638-9009-3-git-send-email-hskinnemoen@atmel.com>
	 <1202834638-9009-4-git-send-email-hskinnemoen@atmel.com>
	 <1202834638-9009-5-git-send-email-hskinnemoen@atmel.com>
	 <20080212204330.GA3184@lixom.net> <20080212231330.79738c3a@siona>
X-Google-Sender-Auth: ea952d59f760bfbf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 12, 2008 3:13 PM, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> On Tue, 12 Feb 2008 14:43:30 -0600
> Olof Johansson <olof@lixom.net> wrote:
>
> > > -   depends on (PCI && X86) || ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX
> > > +   depends on (PCI && X86) || ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX || AVR32
> >
> > This is a slippery slope. Things should be the other way around instead,
> > create a HAVE_DMA_DEVICE, select it in the relevant platform code and
> > make DMADEVICES depend on that.
>
> Agree. I'll cook up a patch tomorrow to make it use the new HAVE_*
> scheme.
>

I suggested something similar here:
http://marc.info/?l=linux-kernel&m=118670671806100&w=2

> > Or just let the subsystem always be available.
>
> It used to be always available, but then it was changed. Assuming there
> was a reason for this change, I guess we don't want to change it back.
>

Adrian had concerns about users enabling NET_DMA when the hardware
capability is relatively rare.  So, +1 for HAVE_DMA_DEVICE

> Haavard

--
Dan
