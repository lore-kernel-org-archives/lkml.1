Return-Path: <linux-kernel-owner+w=401wt.eu-S933250AbZGPUIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250AbZGPUIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 16:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933194AbZGPUIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 16:08:24 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:52205 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933148AbZGPUIY (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 16:08:24 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andy Isaacson <adi@vmware.com>,
       linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
       adi@hexapodia.org, dds@google.com,
       Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>, seiji.munetoh@gmail.com
Subject: Re: [PATCH] TPM: DATA_EXPECT bit check bypass
In-Reply-To: Your message of "Thu, 16 Jul 2009 14:43:32 -0300."
             <1247766212.30736.17.camel@dyn531421.br.ibm.com>
From: Valdis.Kletnieks@vt.edu
References: <1246410255-6839-1-git-send-email-adi@vmware.com> <1246410255-6839-6-git-send-email-adi@vmware.com> <20090701110136.576a1d14@lxorguk.ukuu.org.uk> <1246455920.9140.28.camel@blackbox> <1247765210.30736.3.camel@dyn531421.br.ibm.com>
            <1247766212.30736.17.camel@dyn531421.br.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1247774890_4382P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 16 Jul 2009 16:08:10 -0400
Message-ID: <49514.1247774890@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1247774890_4382P
Content-Type: text/plain; charset=us-ascii

On Thu, 16 Jul 2009 14:43:32 -0300, Rajiv Andrade said:

> @@ -582,6 +585,12 @@ static int tpm_tis_init(struct device *dev, resource_siz
e_t start,
>         tpm_get_timeouts(chip);
>         tpm_continue_selftest(chip);
>  
> +       for (i=0; i < 8; i++)
> +               if (ITPM_ID[i] != to_pnp_dev(dev)->id->id[i])
> +                       break;
> +       if (i == 8)
> +               chip->is_itpm = 1;
> +

strcmp() variant of some sort instead?

--==_Exmh_1247774890_4382P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKX4iqcC3lWbTT17ARAo19AJ9hgceOTzuMGzuL4qR3BdQ53ibH/ACffwQN
lv4PiE4ZsIpON6YuIakZ36M=
=Zaac
-----END PGP SIGNATURE-----

--==_Exmh_1247774890_4382P--
