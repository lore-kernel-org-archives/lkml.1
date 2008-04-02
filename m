Return-Path: <linux-kernel-owner+w=401wt.eu-S1758835AbYDBTQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835AbYDBTQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 15:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbYDBTQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 15:16:24 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:57630 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbYDBTQY (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 15:16:24 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: Miles Lane <miles.lane@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       ipw3945-devel@lists.sourceforge.net, "Zhu, Yi" <yi.zhu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: 2.6.25-rc8-mm1
In-Reply-To: Your message of "Wed, 02 Apr 2008 09:58:46 PDT."
             <D936D925018D154694D8A362EEB089200415A690@orsmsx416.amr.corp.intel.com>
From: Valdis.Kletnieks@vt.edu
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org> <a44ae5cd0804020349v695e22b6k3c273a5724c5d52e@mail.gmail.com>
            <D936D925018D154694D8A362EEB089200415A690@orsmsx416.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1207163740_3351P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 02 Apr 2008 15:15:40 -0400
Message-ID: <6631.1207163740@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1207163740_3351P
Content-Type: text/plain; charset=us-ascii

On Wed, 02 Apr 2008 09:58:46 PDT, "Chatre, Reinette" said:
> On Wednesday, April 02, 2008 3:49 AM, Miles Lane  wrote:
> 
> >  CC [M]  drivers/net/wireless/iwlwifi/iwl3945-base.o
> > drivers/net/wireless/iwlwifi/iwl3945-base.c: In function
> > 'iwl3945_build_tx_cmd_basic':
> > drivers/net/wireless/iwlwifi/iwl3945-base.c:2492: error: 'struct
> > iwl3945_priv' has no member named 'rxtxpackets' 
> > make[4]: *** [drivers/net/wireless/iwlwifi/iwl3945-base.o] Error 1
> > 
> 
> Thanks! John Linville just posted a fix for this problem to
> wireless-testing ("drivers/net/wireless/iwlwifi/iwl-3945.h: correct
> CONFIG_IWL4965_LEDS typo")

And with John's fix, I'm able to build with IWL3945_LEDS defined and
there's now an "ooooh shiny" LED that hasn't worked since I got the laptop. :)

--==_Exmh_1207163740_3351P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFH89tccC3lWbTT17ARAlJmAJ0QI1Ko59ymGsCCc/PkSOymfCPRSgCg3vfI
K/Y7KYH8gAlWWDSplB7Fd8E=
=CmK/
-----END PGP SIGNATURE-----

--==_Exmh_1207163740_3351P--
