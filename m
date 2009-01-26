Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZAZTn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZAZTn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 14:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbZAZTnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 14:43:46 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:24620 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbZAZTnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 14:43:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qrlw5Ckpv0D7TXQr812KeoAGbR2+1D3ggOC46Po+s2dZGFRnMlx0CvVo4eP3+N23Nd
         UrBRZbs17ha/qtgSBbAkFcKdffDMAAajBpwOrUkgJLhR3iQ0WUeo6kEVKMbTRbTdIVFF
         1pAVgfj+VI8n+wiDMcRQGnjIFZJUxBZz1AI8Q=
MIME-Version: 1.0
In-Reply-To: <84144f020901261140j242bb31cg1b2a59a5ae71ae29@mail.gmail.com>
References: <Pine.LNX.4.64.0901221205400.27341@melkki.cs.Helsinki.FI>
	 <20090122114237.GA13845@atrey.karlin.mff.cuni.cz>
	 <4978C812.90702@gmail.com> <20090122211052.GA1928@elf.ucw.cz>
	 <4978F47C.6010909@gmail.com> <4978F3CF.2010301@cs.helsinki.fi>
	 <497E0F94.8000003@gmail.com>
	 <84144f020901261140j242bb31cg1b2a59a5ae71ae29@mail.gmail.com>
Date: Mon, 26 Jan 2009 21:43:41 +0200
X-Google-Sender-Auth: fa4db6035afae7c7
Message-ID: <84144f020901261143o1bb41b76o680c8616a81dc2db@mail.gmail.com>
Subject: Re: [PATCH] w35und: fix usb_control_msg() error handling in 
	wb35_probe()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Sandro Bonazzola <sandro.bonazzola@gmail.com>
Cc: Pavel Machek <pavel@suse.cz>, Greg Kroah-Hartman <greg@kroah.com>,
       linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 9:40 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Hi Sandro,
>
> Pekka Enberg ha scritto:
>>> Ok, test done with git current version of w35und over 2.6.28-gentoo-r1
>>> (2.6.28.1 and some patches)
>>
>> Adding Pekka's patch
>
> On Mon, Jan 26, 2009 at 9:31 PM, Sandro Bonazzola
> <sandro.bonazzola@gmail.com> wrote:
>>> # uname -a
>>> Linux arilinn 2.6.28-gentoo-r1 #1 Wed Jan 21 19:37:07 CET 2009 x86_64 AMD
>>> Athlon(tm) 64 Processor 3500+ AuthenticAMD GNU/Linux
>
> [snip]
>
>> Ok, with kernel 2.6.8.1, and your patch it seems to work with channel 1, no
>> encryption, opensystem authentication.
>
> So the driver doesn't work in 2.6.29-rc1 but does in 2.6.28.1? I
> wonder what changed in the networking/wireless stack that broke the
> winbond driver.... I'm cc'ing netdev even though this is a driver in
> staging.

Actually, it's probably me who broke the driver. I think Greg merged
most of my patches after 2.6.28 came out. Sandro, if you have some
time, please consider doing git bisect to find out which changeset
causes the problem.

                            Pekka
