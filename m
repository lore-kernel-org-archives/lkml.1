Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbXHZXWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbXHZXWL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 19:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbXHZXV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 19:21:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:3521 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbXHZXV5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 19:21:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hYpX4wBCDn5EX3fIqhUHjhNDxmcv6/LOeHjqc0V/FcTGvUyC7Xbh1y1dmDm2NRws8luSzk1Dk8ANYIE2PbLpAgxIj9O6i79WbG6KoWXzLSECWR1NYH+sy/Huxs1MxHYIWifBPBvpUhIjjpgej8i0RE3c0p7uOCpYneEy+toSlrc=
Message-ID: <6bffcb0e0708261621q25316becqce7b3ae2176f45a8@mail.gmail.com>
Date: Mon, 27 Aug 2007 01:21:56 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "=?ISO-8859-1?Q?Rog=E9rio_Brito?=" <rbrito@gmail.com>
Subject: Re: Sleep problems with kernels >= 2.6.21 on powerpc
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       debian-powerpc@lists.debian.org,
       "=?ISO-8859-1?Q?Rog=E9rio_Brito?=" <rbrito@ime.usp.br>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
In-Reply-To: <6540c930708251937o2a9a23efv72a0f2b8947067bd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <6540c930708251937o2a9a23efv72a0f2b8947067bd@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

[Adding STR wizards to CC]

On 26/08/07, Rogério Brito <rbrito@gmail.com> wrote:
> Hi.
>
> Unfortunately, it seems that kernels later than 2.6.21 have problems
> letting my powerpc iBook (G3 processor) going to sleep (suspend to
> ram).
>
> The userland that I am using is a Debian testing (lenny) and the
> default kernel that comes with it is 2.6.22, with some patches applied
> and pbbuttonsd (as the daemon for making the machine sleep).
>
> With kernel 2.6.21, from Debian (and other earlier kernels), the
> symptoms that I see when I press the power button is that the machine
> goes to sleep and the led that indicates that the machine is sleeping
> is blinking normally.
>
> If I, on the other hand, use Debian's kernel 2.6.22 or compile my own
> kernel with just the necessary parts for my work (version 2.6.23-rc3
> taken from kernel.org), then I can't make the machine sleep: when I
> press the button, it acts like if I had, in sequence, pressed anything
> to wake it up (say, like pressing shift).
>
> I have already grabbed Linus's git tree and I am willing to do some
> cycles of "git bisect" to discover the point where it stopped working.
>
> I just thought that others may have seen such behaviour before or, if
> not, that being informative about what I see is of use for debugging
> this.
>
> I would also appreciate any guidance on this as I wish kernel 2.6.23
> to be working again on powerpc machines.
>
> Please, if any tests are required, don't hesitate to ask me and I will
> try to whatever is needed to restore the correct behaviour of sleep
> with the Linux kernel.
>
> I have copied mailing lists that I think that are relevant. If they
> aren't, then please let me know. I would also appreciate if I were
> kept on carbon copies as I am only subscribed to debian-powerpc at the
> moment.
>
>
> Regards, Rogério Brito.
>
> P.S.: It unfortunately doesn't matter if I switch to a console or if I
> am in X when I press the power button with recent kernels.
> -

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
