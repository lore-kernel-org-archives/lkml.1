Return-Path: <linux-kernel-owner+w=401wt.eu-S1751712AbZGaOty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712AbZGaOty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 10:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbZGaOtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 10:49:53 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:41847 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbZGaOtw (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 10:49:52 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Christoph Hellwig <hch@infradead.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Will Newton <will.newton@gmail.com>, dwalker@fifo99.com,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Subject: Re: [RFC][patch 02/12] remove clocksource inline functions
In-Reply-To: Your message of "Thu, 30 Jul 2009 17:48:36 EDT."
             <20090730214836.GB15780@infradead.org>
From: Valdis.Kletnieks@vt.edu
References: <200907291457.n6TEvDAt003701@d06av06.portsmouth.uk.ibm.com> <20090729173231.012d0b89@skybase> <87a5b0800907290836n6bb6da36tb0124e6d4f0673ea@mail.gmail.com> <20090729182754.2361631b@skybase> <28082.1248956470@turing-police.cc.vt.edu>
            <20090730214836.GB15780@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1249041022_20572P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 31 Jul 2009 07:50:22 -0400
Message-ID: <20746.1249041022@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1249041022_20572P
Content-Type: text/plain; charset=us-ascii

On Thu, 30 Jul 2009 17:48:36 EDT, Christoph Hellwig said:
> > You know that a priori because you're familiar with that code. But there's
> > another use case: An idiot monkey like myself manages to break the kernel
> > *again* in some part of the kernel they're totally unfamiliar with, and
> > they need to discover for themselves that timekeeping.c is the only user.
> > 
> > (Of course, in another 5-6 years I'll probably have broken something in
> > every part of the kernel and whinged at Andrew about it, and that argument
> > won't apply anymore.. ;)
> 
> Andthe poor grepping monkey can be sure that everyone used the useless
> wrapper exactly how?  If you want to help people with grepping rename
> the method from read to clocksource_read..

Even better. ;)


--==_Exmh_1249041022_20572P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKctp+cC3lWbTT17ARAlHhAKCLXtejq7xgjvBmWkH2ILNOc8jwhwCfUtx5
0m2yTW4MP0uAkKcBAMTyG4o=
=c8Cs
-----END PGP SIGNATURE-----

--==_Exmh_1249041022_20572P--
