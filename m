Return-Path: <linux-kernel-owner+w=401wt.eu-S932571AbXBNU5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571AbXBNU5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 15:57:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932578AbXBNU5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 15:57:51 -0500
Received: from wr-out-0506.google.com ([64.233.184.230]:11268 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932571AbXBNU5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 15:57:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=LHcJb1WlahWP6GB/W/MN42xAHfHKQxjvDUPIHJSSeZY/a1aOoKM3NOw0wJq4EtYMSBbMWL2mJQAgwBh5MO1GpTvCfgDvVa+0huXPeNtoFbrVt6t2RNnNYwkF06ahAmrmuN1+jXy6OI3huMoWSXOP7I3UgDnRq9grBdaEEH0bWio=
Message-ID: <3ae72650702141257w6b30a8efge5b6109feebb5512@mail.gmail.com>
Date: Wed, 14 Feb 2007 21:57:48 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Marcel Holtmann" <marcel@holtmann.org>, "Tejun Heo" <htejun@gmail.com>,
       "Jeff Garzik" <jeff@garzik.org>
Subject: Re: current git crashes on bootup with pci_iounmap()
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1171385524.3855.2.camel@pim.off.vrfy.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1171380714.3829.6.camel@pim.off.vrfy.org>
	 <1171382645.23580.29.camel@violet>
	 <1171385524.3855.2.camel@pim.off.vrfy.org>
X-Google-Sender-Auth: 2626452140c0d48f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/13/07, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Tue, 2007-02-13 at 17:04 +0100, Marcel Holtmann wrote:
> > > kernel BUG at lib/iomap.c:254!
> > > invalid opcode: 0000 [#1]
> > > ...
> > >
> > > The screen picture is here:
> > >   http://vrfy.org/pci_iounmap.jpg
> > >
> > > It's a Thinkpad T43p.
> > >
> > > 2.6.20 was working fine.
> > >
> > > Commenting out:
> > >   IO_COND(addr, /* nothing */, iounmap(addr));
> > > in:
> > >   lib/iomap.c:254
> > > makes at least booting up possible.
> >
> > I saw a similar one on my X41. Disabling the AHCI driver made the
> > machine booting again.
>
> Hey Marcel,
> yeah, that works fine here too.

Tejun, Jeff, any ideas what's going wrong with the iomap change and
the AHCI driver?

Thanks,
Kay
