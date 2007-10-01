Return-Path: <linux-kernel-owner+w=401wt.eu-S1752933AbXJALmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbXJALmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 07:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbXJALmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 07:42:35 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:21604 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbXJALmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 07:42:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VBEdqpyQ9Z8MjKs+I05V9U4N+7N6DYqVS7oTRg+Ykb/yH7o/39jP8GTQO2jsnDx0t1FjNzQF0vM7y2qRGmkyFbQRAdGrb0HRkxrzoHNWVGRetmHq5yXYBo7KDE7OHie9mI4gcxUTQ3nxk0BJYdHeEq7HZJavcmXweXxaGOmoZSY=
Message-ID: <be1b757c0710010442w2dbf6751g259b8cb3354a929e@mail.gmail.com>
Date: Mon, 1 Oct 2007 13:42:30 +0200
From: "Karl Meyer" <adhocrocker@gmail.com>
To: "Francois Romieu" <romieu@fr.zoreil.com>
Subject: Re: PROBLEM: 2.6.23-rc "NETDEV WATCHDOG: eth0: transmit timed out"
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20070912205025.GA31709@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <be1b757c0708130435y689b9dd8raf9ac9f9c0fcc976@mail.gmail.com>
	 <be1b757c0708131027v5c57822as2d9bd3190fd19b71@mail.gmail.com>
	 <20070814070901.GA14693@electric-eye.fr.zoreil.com>
	 <be1b757c0708141425qd887581n3922702b84a21758@mail.gmail.com>
	 <20070814224629.GB3495@electric-eye.fr.zoreil.com>
	 <20070816141122.GA6625@electric-eye.fr.zoreil.com>
	 <be1b757c0709011224tafebaaby697d03ab5377e20f@mail.gmail.com>
	 <6bffcb0e0709021515v586f078cjce04f877e2f27aa2@mail.gmail.com>
	 <be1b757c0709021521q850f2bdq3f88c24c02c26b1b@mail.gmail.com>
	 <20070912205025.GA31709@electric-eye.fr.zoreil.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

after reading about issues with the nics on kontron boards I did a
bios upgrade,
but this did not change anything.
However, yesterday the nic (onboard) I used died. No link at all,
after switching to
the next onboard  nic I got a NETDEV transmit timeout with that one on
kernel 2.6.22-r2.
It seems the whole thing is a hardware issue. I will try to figure out
with kontron.

Sorry :(

Karl

2007/9/12, Francois Romieu <romieu@fr.zoreil.com>:
> Karl Meyer <adhocrocker@gmail.com> :
> [...]
> > am am looking for this issue for some time now, but there where no
> > errors in 2.6.22-r2 (gentoo speak, I guess this is 2.6.22.2
> > officially), I also ran git-bisect (for more information see the older
> > messages in this thread).
>
> 2.6.22-r2 in gentoo is based on 2.6.22.1. It is way before
> 0e4851502f846b13b29b7f88f1250c980d57e944 that you reported to work.
> Thus it is not surprizing that it works.
>
> Any update regarding the patchkit that I sent on 2007/08/16 ?
>
> It would help to narrow the culprit.
>
> --
> Ueimor
>
