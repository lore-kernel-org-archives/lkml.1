Return-Path: <linux-kernel-owner+w=401wt.eu-S1752000AbXCHOkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbXCHOkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 09:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbXCHOkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 09:40:20 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:45618 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbXCHOkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 09:40:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=WY+LsgjGIstZOKAWqkE+i+MLyisgmH/Gf5JTWN78Vvf00T4SKdj0UEchr44yZPDL7zahgSqj2UTpxw2SxeJPnONsaArNY9qLdLKl6azFK1kIiR5/omuZddxOvN0r+UQ4z8ZAa6U740yrmdm2x3sK/KIai97MvfetjAaqE6f2bL0=
Message-ID: <57354eff0703080640h65ebf6eay69e5eab048812aab@mail.gmail.com>
Date: Thu, 8 Mar 2007 15:40:15 +0100
From: "Oleksiy Kebkal" <lesha@evologics.de>
To: "Robin Getz" <rgetz@blackfin.uclinux.org>,
       "Krzysztof Halasa" <khc@pm.waw.pl>,
       "Mike Frysinger" <vapier.adi@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org
Subject: Re: should RTS init in serial core be tied to CRTSCTS
In-Reply-To: <20070308142849.GC30023@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0703011603m794e00f5x875eb68ad0db05de@mail.gmail.com>
	 <200703071019.55896.rgetz@blackfin.uclinux.org>
	 <57354eff0703071330k2395e9c8n58e12f2111dcb25a@mail.gmail.com>
	 <200703080844.32157.rgetz@blackfin.uclinux.org>
	 <20070308134800.GA30023@flint.arm.linux.org.uk>
	 <57354eff0703080623r2f7f88c3r7ddf6381061cbd73@mail.gmail.com>
	 <20070308142849.GC30023@flint.arm.linux.org.uk>
X-Google-Sender-Auth: 965de8358eb60848
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/3/8, Russell King <rmk+lkml@arm.linux.org.uk>:
> On Thu, Mar 08, 2007 at 03:23:49PM +0100, Oleksiy Kebkal wrote:
> > Ok. I understand now one of the sources of misunderstanding. I don't
> > want to mix console and application serial port.
>
> It's not a misunderstanding if you realise that email is threaded and
> you _follow_ the individual threads.  Robin has a similar concern to
> you but _additionally_ wants something that you don't.
>
> So really to remove the "confusion" from this discussion you should
> avoid trying to correct replies to Robin's emails.

On some stages it was very close... Anyway, sorry...

> > The other problem is how to open serial port with correct settings
> > _after_ booting. In this case /proc could be applicable, isn't it?
>
> Doubt it with todays opinions about /proc contents.  Probably more
> appropriate in sysfs, if someone can be bothered to do the work
> required to properly integrate tty and sysfs.
>
> Don't look at me; I'm not doing very much with serial anymore.

I don't. :) Surely I'm not experienced kernel developer, but I would
like to do it. :)
The only purpose of my remarks and questions was to find the best
origin of force
to solve this problem. And all remarks in this thread are very valuable for me.

-Oleksiy
