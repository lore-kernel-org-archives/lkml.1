Return-Path: <linux-kernel-owner+w=401wt.eu-S1751998AbXFDDQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbXFDDQA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 23:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbXFDDPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 23:15:52 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:55934 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbXFDDPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 23:15:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=WDFJRvqCXErqPrHmnTVuP/RupVfJ+8/23FkUu235iF1f8UKO7jr6YoKw/1QjFyFBAO6tMXYUNrWAOIkjYvXB6OixFVEBw4vUbovjEGhcERuPktSdAr6StbrSU1V5l1f99kk0giXKr6jB3yrCGb3QI/s74bKS28BmhfBdOX5iA4g=
Message-ID: <b3ece790706032015u28966876x7bee35ea24e81fe5@mail.gmail.com>
Date: Sun, 3 Jun 2007 20:15:50 -0700
From: "Tim Hockin" <thockin@hockin.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: Kconfig variable "COBALT" is not defined anywhere
Cc: "Tim Hockin" <thockin@google.com>, "Roland Dreier" <rdreier@cisco.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706031747190.23873@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0706031315230.23477@localhost.localdomain>
	 <20070603132309.508738b7.randy.dunlap@oracle.com>
	 <Pine.LNX.4.64.0706031630030.26035@localhost.localdomain>
	 <adazm3glqcr.fsf@cisco.com>
	 <cc96a5040706031408i54116922m7a83c7e0b07181e6@mail.gmail.com>
	 <Pine.LNX.4.64.0706031714070.19004@localhost.localdomain>
	 <cc96a5040706031438o667e4df0wb18bdd071f48e246@mail.gmail.com>
	 <Pine.LNX.4.64.0706031747190.23873@localhost.localdomain>
X-Google-Sender-Auth: 27ce7cb54a413078
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

That sounds correct.

On 6/3/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> On Sun, 3 Jun 2007, Tim Hockin wrote:
>
> > I think the nvram is the only place left that uses CONFIG_COBALT
>
> sure, but once you remove this snippet near the top of
> drivers/char/nvram.c:
>
> ...
> #  if defined(CONFIG_COBALT)
> #    include <linux/cobalt-nvram.h>
> #    define MACH COBALT
> #  else
> #    define MACH PC
> #  endif
> ...
>
> then everything else COBALT-related in that file should be tossed as
> well, which would include stuff conditional on:
>
>   #if MACH == COBALT
>
> and so on.  just making sure that what you're saying is that *all*
> COBALT-related content in that file can be thrown out.  i'll submit a
> patch shortly and you can pass judgment.
>
> rday
> --
> ========================================================================
> Robert P. J. Day
> Linux Consulting, Training and Annoying Kernel Pedantry
> Waterloo, Ontario, CANADA
>
> http://fsdev.net/wiki/index.php?title=Main_Page
> ========================================================================
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
