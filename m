Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbYBEIJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbYBEIJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 03:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbYBEIJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 03:09:05 -0500
Received: from mx1.suse.de ([195.135.220.2]:35640 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbYBEIJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 03:09:04 -0500
Date: Tue, 5 Feb 2008 09:09:00 +0100
From: Bernhard Walle <bwalle@suse.de>
To: "Sachin P. Sant" <sachinp@in.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, kexec@lists.infradead.org
Subject: Re: [mm] Crashkernel memory reservation fails with 2.6.24-rc8-mm1
Message-ID: <20080205080900.GB30563@suse.de>
Mail-Followup-To: "Sachin P. Sant" <sachinp@in.ibm.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	kexec@lists.infradead.org
References: <47A7391F.2020408@in.ibm.com> <20080204183810.GE16021@redhat.com> <20080204193524.GA11104@suse.de> <47A7F53C.8090606@in.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+pHx0qQiF2pBVqBT"
Content-Disposition: inline
In-Reply-To: <47A7F53C.8090606@in.ibm.com>
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+pHx0qQiF2pBVqBT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Sachin P. Sant <sachinp@in.ibm.com> [2008-02-05 06:33]:
> Bernhard Walle wrote:
>> * Vivek Goyal <vgoyal@redhat.com> [2008-02-04 19:38]:
>>  =20
>>> Bernahard, any idea who is the competitor here?
>>>    =20
>> Hm ..., can you boot the kernel without crashkernel=3D and provide the
>> /proc/iomem?
>>  =20
> Attached is the /proc/iomem output with and without crashkernel
> parameter.

Looks ok. In my case when I added the warning message the kernel BSS
was too large. But that doesn't seem to be the case here, BSS ends
with 9M and you use 16M as start address for the crashkernel.


        Bernhard

--+pHx0qQiF2pBVqBT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQFHqBmciGU2lt2vZFQRAmWeAJ9llKxtEBcATo8q/CHr0AjvAUsfZACgnDIc
F4jkDcLlPNKMrX7yRDuXST0=
=3qDb
-----END PGP SIGNATURE-----

--+pHx0qQiF2pBVqBT--
