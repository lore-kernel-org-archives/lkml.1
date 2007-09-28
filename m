Return-Path: <linux-kernel-owner+w=401wt.eu-S1756026AbXI1L72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbXI1L72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 07:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbXI1L7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 07:59:21 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:27544 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbXI1L7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 07:59:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lnm3AcEk5pVOqZpY/bfdaU0KhIjPsS+dE0SQY5wawUumddnuKpzzdbHlz7M5F4AZIpq2FAupu+QKQah4xgurWEtuBuluvOgJv2Jc1rPQLCfD7645x3wiQK2eTWjA6hoV7v5x0HYV8I/XXdZLltla1su7OFDrEoEBRS/OF6xHl4w=
Message-ID: <19f34abd0709280459w13266dd4n24b38f90fe5c0ccf@mail.gmail.com>
Date: Fri, 28 Sep 2007 13:59:19 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: [RFC] New kernel-message logging API (take 2)
Cc: LKML <linux-kernel@vger.kernel.org>, "Kyle Moffett" <mrmacman_g4@mac.com>,
       "Michael Holzheu" <holzheu@linux.vnet.ibm.com>,
       "Joe Perches" <joe@perches.com>, "Rob Landley" <rob@landley.net>,
       "Dick Streefland" <dick.streefland@altium.nl>,
       "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       "Arnd Bergmann" <arnd@arndb.de>,
       "Emil Medve" <Emilian.Medve@freescale.com>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "linux@horizon.com" <linux@horizon.com>
In-Reply-To: <Pine.LNX.4.64.0709281139460.25099@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0709271418l471cf7b9gf24161190772fac@mail.gmail.com>
	 <Pine.LNX.4.64.0709281139460.25099@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/28/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Sep 27 2007 23:18, Vegard Nossum wrote:
> >  * kprint_<level>() is better than kprint(<level), ) because in the
> >    case of the default log-level, the argument can be omitted.
> >  * Memory allocated for entries and arguments is done in a ring-buffer
> >    with variable-sized chunks. Arguments are chained with a singly-
> >    linked list.
> >  * Use SUBSYSTEM and KBUILD_MODNAME
> >  * Rename kprint buffers to kprint blocks
>
> This is overall, quite a lot. I suggest one-thing-at-a-time,
> starting with kprint_<level>() that is compiled out if desired
> and no fancy block or newline stuff.
>
> _Then_, will see how it flies. All of this smells like a bit of
> overdesigning, aka http://en.wikipedia.org/wiki/YAGNI

Well, that's why I'm writing it down before actually coding it.
Designing is also trying to make things fit together without actually
having the physical parts at hand. So I'm trying to make an interface
that CAN support multi-line blocks in the future, since it's obviously
a desired (and currently missing) feature.

But I agree; It *is* hard to see how multi-line blocks can be
implemented without actually spelling it out in code. I've tried to do
it, and failed. Until a brilliant solution comes up, I'll skip it.

Vegard
