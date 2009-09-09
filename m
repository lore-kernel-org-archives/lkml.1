Return-Path: <linux-kernel-owner+w=401wt.eu-S1751668AbZIIFya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbZIIFya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 01:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbZIIFy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 01:54:29 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:34631 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbZIIFy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 01:54:28 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: akataria@vmware.com
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA - V4.
Date: Wed, 9 Sep 2009 07:54:15 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc9-git; KDE/4.3.1; i686; ; )
Cc: Daniel Walker <dwalker@fifo99.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Brian King <brking@linux.vnet.ibm.com>,
       "Chetan.Loke@Emulex.Com" <Chetan.Loke@emulex.com>,
       Matthew Wilcox <matthew@wil.cx>, Roland Dreier <rdreier@cisco.com>,
       Bart Van Assche <bvanassche@acm.org>,
       Robert Love <robert.w.love@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>
References: <1252458903.24914.73.camel@ank32.eng.vmware.com> <1252459596.14793.46.camel@desktop> <1252472481.2508.20.camel@ank32.eng.vmware.com>
In-Reply-To: <1252472481.2508.20.camel@ank32.eng.vmware.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3765641.eRLI5YlOxm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200909090754.22778.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3765641.eRLI5YlOxm
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Alok Kataria wrote:

> +/* Command line parameters */
> +static int pvscsi_ring_pages     = PVSCSI_DEFAULT_NUM_PAGES_PER_RING;
> +static int pvscsi_msg_ring_pages = PVSCSI_DEFAULT_NUM_PAGES_MSG_RING;
> +static int pvscsi_cmd_per_lun    = PVSCSI_DEFAULT_QUEUE_DEPTH;
> +static int pvscsi_disable_msi;
> +static int pvscsi_disable_msix;
> +static int pvscsi_use_msg        = true;

Should be bool.

Do I get annoying? ;)

Eike

--nextPart3765641.eRLI5YlOxm
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkqnQw4ACgkQXKSJPmm5/E6gQQCfauBF7DKWE/QD2srAuOJeNcnT
T58AnjCuaNp8lWsFkCLfa+ae+INooB+g
=tzC2
-----END PGP SIGNATURE-----

--nextPart3765641.eRLI5YlOxm--
