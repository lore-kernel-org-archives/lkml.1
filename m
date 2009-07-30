Return-Path: <linux-kernel-owner+w=401wt.eu-S1751825AbZG3OSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbZG3OSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 10:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZG3OSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 10:18:35 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:44376 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbZG3OSe (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 10:18:34 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Will Newton <will.newton@gmail.com>, dwalker@fifo99.com,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Subject: Re: [RFC][patch 02/12] remove clocksource inline functions
In-Reply-To: Your message of "Wed, 29 Jul 2009 18:27:54 +0200."
             <20090729182754.2361631b@skybase>
From: Valdis.Kletnieks@vt.edu
References: <200907291457.n6TEvDAt003701@d06av06.portsmouth.uk.ibm.com> <20090729173231.012d0b89@skybase> <87a5b0800907290836n6bb6da36tb0124e6d4f0673ea@mail.gmail.com>
            <20090729182754.2361631b@skybase>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1248956469_2641P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 30 Jul 2009 08:21:10 -0400
Message-ID: <28082.1248956470@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1248956469_2641P
Content-Type: text/plain; charset=us-ascii

On Wed, 29 Jul 2009 18:27:54 +0200, Martin Schwidefsky said:
> On Wed, 29 Jul 2009 16:36:46 +0100 Will Newton <will.newton@gmail.com> wrote:

> > An argument for the helper is that it eases grepability. Sure you can
> > search for "->read" but that's going to turn up all kinds of
> > non-clocksource code as well. grep clocksource_read will get you
> > exactly what you want.
> 
> That would make sense if the clocksource_read calls are littered all
> over the kernel source. But they are not, the only user is
> timekeeping.c

You know that a priori because you're familiar with that code. But there's
another use case: An idiot monkey like myself manages to break the kernel
*again* in some part of the kernel they're totally unfamiliar with, and
they need to discover for themselves that timekeeping.c is the only user.

(Of course, in another 5-6 years I'll probably have broken something in
every part of the kernel and whinged at Andrew about it, and that argument
won't apply anymore.. ;)

--==_Exmh_1248956469_2641P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKcZA1cC3lWbTT17ARAlToAJ0XjcvzO6pk6lX2zHvNHsbWisbyKACg+Rqr
yNoKvyKJKPSfketbSXinF9U=
=7ue6
-----END PGP SIGNATURE-----

--==_Exmh_1248956469_2641P--
