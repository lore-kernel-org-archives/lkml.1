Return-Path: <linux-kernel-owner+w=401wt.eu-S1761528AbXEZTES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761528AbXEZTES (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 15:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755119AbXEZTEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 15:04:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:44871 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754957AbXEZTEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 15:04:01 -0400
X-Authenticated: #8359428
X-Provags-ID: V01U2FsdGVkX18fy5x9/2wfJ4GmDZTT+Vh/WHE6RdKK8K1dNCp0hu
	AON+DHOLrdTb5U
From: Uwe Bugla <uwe.bugla@gmx.de>
To: "Benoit Boissinot" <bboissin@gmail.com>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Date: Sat, 26 May 2007 20:58:37 +0200
User-Agent: KMail/1.9.5
References: <20070524195616.234280@gmx.net> <200705261918.09469.mb@bu3sch.de> <40f323d00705261141m7c32d2b8h7059b4b35ed066c9@mail.gmail.com>
In-Reply-To: <40f323d00705261141m7c32d2b8h7059b4b35ed066c9@mail.gmail.com>
Cc: "Michael Buesch" <mb@bu3sch.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Maximilian Engelhardt" <maxi@daemonizer.de>,
       linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705262058.37454.uwe.bugla@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 26. Mai 2007 20:41 schrieben Sie:
> On 5/26/07, Michael Buesch <mb@bu3sch.de> wrote:
> > On Saturday 26 May 2007 19:04:04 Uwe Bugla wrote:
> > > Yes, sure! But the help text is very unlucky and humble, and it is not
> > > clear enough in the sense of being distinctive enough, just clear and
> > > comprehensive.
> >
> > Why don't you simply submit a patch to change the helptext then?
>
> Is that ok ?
>
> Discourage people from deselecting B44_PCI
>
> Signed-off-by: Benoit Boissinot <benoit.boissinot@ens-lyon.org>
>
> --- kernel.orig/drivers/net/Kconfig	2007-05-26 20:38:02.000000000 +0200
> +++ kernel/drivers/net/Kconfig	2007-05-26 20:38:15.000000000 +0200
> @@ -1449,7 +1449,7 @@
>  	help
>  	  Support for b44 PCI devices.
>
> -	  Say Y
> +	  Unless you know what you are doing, say Y here.
>
>  config FORCEDETH
>  	tristate "nForce Ethernet support"

No, That is NOT OK! That's nothing but a joke, and if it is a joke : )
it hits well in Mister Buesches direction. In so far it's 
well-done : ) : ) : )

To be honest:

I expect at least TWO explained cases:

A. The case in which the b44 module is a PCI module (onboard, additional PCI 
card etc.).

B. At least one well described case in which the b44 module is a bus 
independent one.

Apart from that, it is Michael's task to explain the what and why, not mine 
and not yours! It is him that wants his stuff being pulled into mainline, and 
in so far he very well can do the "dirty work" of documentation, explanation.

But the issue is: He is not ready to DO that! Only if it fires back!

Cheers

Uwe
