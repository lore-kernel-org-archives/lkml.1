Return-Path: <linux-kernel-owner+w=401wt.eu-S1757643AbZLEDVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643AbZLEDVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 22:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756007AbZLEDVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 22:21:41 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39814 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389AbZLEDVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 22:21:40 -0500
Date: Sat, 5 Dec 2009 14:21:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Emese Revfy <re.emese@gmail.com>
Cc: tony.luck@intel.com, geoffrey.levand@am.sony.com, davem@davemloft.net,
       tglx@linutronix.de, joerg.roedel@amd.com, muli@il.ibm.com,
       jdmason@kudzu.us, jbarnes@virtuousgeek.org, dwmw2@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/31] Constify struct dma_map_ops for 2.6.32 v1
Message-Id: <20091205142140.d8954929.sfr@canb.auug.org.au>
In-Reply-To: <4B19CAF1.8010705@gmail.com>
References: <4B198670.2000406@gmail.com>
	<4B1989B0.102@gmail.com>
	<20091205115936.d3a7a6ec.sfr@canb.auug.org.au>
	<20091205122015.c898e234.sfr@canb.auug.org.au>
	<4B19BEB9.3000600@gmail.com>
	<20091205131011.e90d7f1c.sfr@canb.auug.org.au>
	<4B19C493.4030506@gmail.com>
	<20091205132724.154a07b6.sfr@canb.auug.org.au>
	<4B19CAF1.8010705@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__5_Dec_2009_14_21_40_+1100_Qol7Jq=BVkxsts5w"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__5_Dec_2009_14_21_40_+1100_Qol7Jq=BVkxsts5w
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Emese,

On Sat, 05 Dec 2009 03:52:33 +0100 Emese Revfy <re.emese@gmail.com> wrote:
>
> @@ -1232,7 +1231,7 @@ struct vio_dev *vio_register_device_node(struct dev=
ice_node *of_node)
>  	viodev->dev.archdata.of_node =3D of_node_get(of_node);
> =20
>  	if (firmware_has_feature(FW_FEATURE_CMO))
> -		vio_cmo_set_dma_ops(viodev);
> +		viodev->dev.archdata.dma_ops =3D &vio_dma_mapping_ops;
>  	else
>  		viodev->dev.archdata.dma_ops =3D &dma_iommu_ops;
>  	set_iommu_table_base(&viodev->dev, vio_build_iommu_table(viodev));

You forgot to remove this hunk.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__5_Dec_2009_14_21_40_+1100_Qol7Jq=BVkxsts5w
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksZ0cQACgkQjjKRsyhoI8yHbQCgskWLmQ7pJpLnxtfdKedEUGji
thoAnjvKjsV/ODIMRsoC4aXkKlyqSahx
=J/xX
-----END PGP SIGNATURE-----

--Signature=_Sat__5_Dec_2009_14_21_40_+1100_Qol7Jq=BVkxsts5w--
