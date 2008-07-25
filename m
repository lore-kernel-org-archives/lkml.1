Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbYGYIKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbYGYIKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 04:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbYGYIKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 04:10:11 -0400
Received: from sprocket.fensystems.co.uk ([212.13.204.53]:36959 "EHLO
	sprocket.fensystems.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbYGYIKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 04:10:10 -0400
X-Greylist: delayed 2038 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jul 2008 04:10:10 EDT
Date: Fri, 25 Jul 2008 08:35:55 +0100 (BST)
From: Michael Brown <mbrown@fensystems.co.uk>
X-X-Sender: mcb30@dolphin.home
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: sfx.c driver build failure
In-Reply-To: <1216966559.11188.85.camel@pasglop>
Message-ID: <Pine.LNX.4.62.0807250831440.8217@dolphin.home>
References: <1216966559.11188.85.camel@pasglop>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="656896-1967781521-1216971355=:8217"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--656896-1967781521-1216971355=:8217
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 25 Jul 2008, Benjamin Herrenschmidt wrote:
> The sfx driver (which happens to be part of some of our test configs)=20
> fails to build in current Linus tree on powerpc with this error:
>=20
> /home/benh/kernels/linux-powerpc/drivers/net/sfc/efx.c: In function =FF=
=FFefx_probe_interrupts=FF=FF:
> /home/benh/kernels/linux-powerpc/drivers/net/sfc/efx.c:845: error: lvalue=
 required as unary =FF=FF&=FF=FF oper
> and

I'm not the maintainer of that code; I wrote the original version, but=20
it's now maintained by Solarflare.

I don't see anything on that line that ought to be architecture-specific. =
=20
Could you send me the preprocessed efx.c from your powerpc build?

Michael
--656896-1967781521-1216971355=:8217--
