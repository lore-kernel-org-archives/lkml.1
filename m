Return-Path: <linux-kernel-owner+w=401wt.eu-S967027AbXEHMpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967027AbXEHMpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 08:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934595AbXEHMpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 08:45:06 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37831 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934673AbXEHMpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 08:45:04 -0400
Date: Tue, 8 May 2007 22:44:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Klein <osstklei@de.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>, Thomas Klein <tklein@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>, netdev <netdev@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <ossrosch@linux.vnet.ibm.com>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>
Subject: Re: [PATCH] ehea: Receive SKB Aggregation
Message-Id: <20070508224459.7a46e1e4.sfr@canb.auug.org.au>
In-Reply-To: <200705081405.33742.osstklei@de.ibm.com>
References: <200705081405.33742.osstklei@de.ibm.com>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__8_May_2007_22_44_59_+1000_2D.TR.V1=VgSWO2="
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_May_2007_22_44_59_+1000_2D.TR.V1=VgSWO2=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Tue, 8 May 2007 14:05:33 +0200 Thomas Klein <osstklei@de.ibm.com> wrote:
>
> +struct ehea_lro {
> +	struct sk_buff *parent;
> +	struct sk_buff *last_skb;
> +        struct iphdr *iph;
> +        struct tcphdr *tcph;
   ^^^^^^^^
Spaces instead of tabs.

Also in at least one other place in this patch.

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__8_May_2007_22_44_59_+1000_2D.TR.V1=VgSWO2=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGQHDRFdBgD/zoJvwRAjwxAJ9UTT3P1RuptBk7k8kJXiwDQ9g4/QCgjyrM
NRwkVc8qbfnHZoI31ZxMCo4=
=gY89
-----END PGP SIGNATURE-----

--Signature=_Tue__8_May_2007_22_44_59_+1000_2D.TR.V1=VgSWO2=--
