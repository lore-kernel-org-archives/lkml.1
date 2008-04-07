Return-Path: <linux-kernel-owner+w=401wt.eu-S1756500AbYDGIPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbYDGIPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 04:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbYDGIPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 04:15:20 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:23911 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbYDGIPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 04:15:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=r3IH6HX00/X1/sOiiHnfILHTvZqpt+9EcxWCqP4JVPciE3EOG8PZR5/74DzpYUT5RzoaDnh+4biJW4b1//89i2tAOKkBP2feiG5b24OLNdCOl2li0TAzjjiEfh0rHXHNXhbDqtuvwGKXItItL4VkOmHiG2Eo6zSbbmyPsSnAHCM=
Message-ID: <386072610804070115s57dfd49fgad01218e820167b@mail.gmail.com>
Date: Mon, 7 Apr 2008 01:15:18 -0700
From: "Bryan Wu" <cooloney@kernel.org>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: Blackfin STAMP537 compiling error in 2.6.25-rc8
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, magnus.damm@gmail.com,
       damm@igel.co.jp, lethal@linux-sh.org, nico@cam.org,
       "Mike Frysinger" <vapier.adi@gmail.com>
In-Reply-To: <47F9D7BA.6080708@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <386072610804070057w1eb65db5taeca77f8f3e36627@mail.gmail.com>
	 <47F9D7BA.6080708@garzik.org>
X-Google-Sender-Auth: fadcbcc5f6c5f142
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 7, 2008 at 1:13 AM, Jeff Garzik <jeff@garzik.org> wrote:
>
> Bryan Wu wrote:
>
> > We found the latest kernel compile failed with Blackfin STAMP537
> > configuration on our daily build machine.
> > ---
> >  CC      drivers/net/smc91x.o
> > drivers/net/smc91x.c: In function 'smc_rcv':
> > drivers/net/smc91x.c:513: warning: passing argument 1 of 'insw' makes
> > integer from pointer without a cast
> > drivers/net/smc91x.c: In function 'smc_hardware_send_pkt':
> > drivers/net/smc91x.c:620: warning: passing argument 1 of 'outsw' makes
> > integer from pointer without a cast
> > drivers/net/smc91x.c:1859:32: error: macro "SMC_GET_MAC_ADDR" requires
> > 2 arguments, but only 1 given
> > drivers/net/smc91x.c: In function 'smc_probe':
> > drivers/net/smc91x.c:1859: error: 'SMC_GET_MAC_ADDR' undeclared (first
> > use in this function)
> > drivers/net/smc91x.c:1859: error: (Each undeclared identifier is
> > reported only once
> > drivers/net/smc91x.c:1859: error: for each function it appears in.)
> > make[2]: *** [drivers/net/smc91x.o] Error 1
> > make[1]: *** [drivers/net] Error 2
> > make: *** [drivers] Error 2
> > ---
> >
> > That is because my -mm tree fixing bug patch:
> >
> (http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9e6db60825ef7e7999abc610ce256ba768e58162)
> > was merged into mainline before the smc91x API change patch in -mm:
> >
> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc5/2.6.25-rc5-mm1/broken-out/smc91x-pass-along-private-data-v2.patch
> >
> > Did I miss something here? or this patch is on the way before 2.6.25
> > final release?
> >
>
>  It looks like I missed something...  I thought akpm was going to send the
> patch for -mm in?
>
>  If not, let's revert this one...
>

ok, no problem, it is ok for me.

Thanks
-Bryan
