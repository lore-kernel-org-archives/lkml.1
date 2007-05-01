Return-Path: <linux-kernel-owner+w=401wt.eu-S932192AbXEADpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbXEADpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 23:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932398AbXEADpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 23:45:52 -0400
Received: from terminus.zytor.com ([192.83.249.54]:40168 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbXEADpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:45:50 -0400
Message-ID: <4636B7DE.5050005@zytor.com>
Date: Mon, 30 Apr 2007 20:45:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Jeff Garzik <jeff@garzik.org>,
       Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <20070428758.455116000@suse.de>	 <20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>	 <m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com> <4634483E.9030307@goop.org>	 <m14pmz8bbb.fsf@ebiederm.dsl.xmission.com>	 <1177902195.30071.203.camel@localhost.localdomain>	 <463572B7.90202@zytor.com>	 <1177909434.30071.216.camel@localhost.localdomain>	 <m1ejm16flv.fsf@ebiederm.dsl.xmission.com> <1177990722.28659.39.camel@localhost.localdomain>
In-Reply-To: <1177990722.28659.39.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> 
> It'd be nicer if there were a "struct boot_params" declaration, but we
> can't have everything.

It's in my patchset-under-development.

(Preview snapshot:
http://userweb.kernel.org/~hpa/setup-snapshot-2007.04.30.patch)

> diff -r 9a673a220ad6 Documentation/lguest/lguest.c
> --- a/Documentation/lguest/lguest.c	Mon Apr 30 20:10:26 2007 +1000
> +++ b/Documentation/lguest/lguest.c	Tue May 01 13:19:02 2007 +1000
> @@ -30,10 +30,12 @@
>  #include <termios.h>
>  #include <getopt.h>
>  #include <zlib.h>
> +typedef unsigned long long u64;
>  typedef uint32_t u32;
>  typedef uint16_t u16;
>  typedef uint8_t u8;

Why not uint64_t to go along with all the other defines?

	-hpa
