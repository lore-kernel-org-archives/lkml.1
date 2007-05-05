Return-Path: <linux-kernel-owner+w=401wt.eu-S933631AbXEERJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933631AbXEERJM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 13:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933636AbXEERJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 13:09:12 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:46724 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933631AbXEERJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 13:09:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LdDx2tLDGzN4TTMhhYHt93+1N0U87Cr9CJ//hvocOa2dwUp181o0QPEnfrIgVNJ7NOWnugqc9jGiNVy+yqMHY9CuihWAHZe/tnvds4QsST+c2P07y3diect05u2a21PkVOBtj5PfIyghwoD3d0JqTMFpjm4rQgiDo0aSXsnaLE8=
Message-ID: <5486cca80705051009n1f84381dxc5c7ea17ea701e31@mail.gmail.com>
Date: Sat, 5 May 2007 19:09:10 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Paul Fulghum" <paulkf@microgate.com>
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible bug]
Cc: "Oliver Neukum" <oliver@neukum.org>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1178384186.3379.23.camel@x2>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	 <463CB429.6050201@microgate.com> <1178381287.3379.8.camel@x2>
	 <200705051846.57112.oliver@neukum.org> <1178384186.3379.23.camel@x2>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/5, Paul Fulghum <paulkf@microgate.com>:
> On Sat, 2007-05-05 at 18:46 +0200, Oliver Neukum wrote:
> > Am Samstag, 5. Mai 2007 18:08 schrieb Paul Fulghum:
> > > I would argue that cdc-acm should do the same as the serial driver.
> >
> > Has this been tested?
> > If so we could reduce the complexity of the throtteling logic in the usb
> > drivers.
>
> Antonino is doing so now.
>
> I think Alan nailed it: with the old tty buffering the extra
> logic was required to avoid data loss. The new tty buffering
> handles large blocks of data with no problem.
>

When I hit the problem originally I was using an FTDI device. I've
tested it on multiple 3 linux machine machine: Ubuntu Dapper (kernel
2.6.15), Fedora Core 2 (dunno what kernel but surely older that
2.6.15) and Debian Etch (with 2.6.20 and 2.6.21) and all of then gave
me corrupted data (while windows gave correct data). So all these
kernel have this (or a related) problem.


  ~ Antonio
