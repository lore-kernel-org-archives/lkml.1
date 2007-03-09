Return-Path: <linux-kernel-owner+w=401wt.eu-S2992924AbXCID2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992924AbXCID2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 22:28:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992927AbXCID2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 22:28:14 -0500
Received: from h80ad26d9.async.vt.edu ([128.173.38.217]:50074 "EHLO
	h80ad26d9.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992924AbXCID2N (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 22:28:13 -0500
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Mar 2007 22:28:12 EST
Message-Id: <200703090319.l293JrpC009714@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com, zohar@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] [Patch 1/1] IBAC Patch
In-Reply-To: Your message of "Thu, 08 Mar 2007 17:58:16 EST."
             <1173394696.5981.12.camel@localhost.localdomain>
From: Valdis.Kletnieks@vt.edu
References: <1173394696.5981.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1173410393_8499P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 08 Mar 2007 22:19:53 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1173410393_8499P
Content-Type: text/plain; charset=us-ascii

On Thu, 08 Mar 2007 17:58:16 EST, Mimi Zohar said:
> This is a request for comments for a new Integrity Based Access
> Control(IBAC) LSM module which bases access control decisions
> on the new integrity framework services. 
> 
> (Hopefully this will help clarify the interaction between an LSM 
> module and LIM module.)

OK, between this and the additional LIM hooks I didn't notice in an earlier
patch, we're starting to see the API.   The only problem is that although
it may be the right API for *your* code, I suspect it's a non-starter without
a discussion about whether it's the right *generic* API for an LIM (which will
require at least one dramatic bun fight about what "Integrity" means).

> Index: linux-2.6.21-rc3-mm2/security/ibac/Kconfig
 
Minor congnitive-dissonance alert:

> +config SECURITY_IBAC_BOOTPARAM
> +	bool "IBAC boot parameter"
> +	depends on SECURITY_IBAC
> +	default y

> +	  If you are unsure how to answer this question, answer N.

The 'default' should in general match the hint we give the user.

--==_Exmh_1173410393_8499P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFF8NJZcC3lWbTT17ARAiIuAKCsfxS/i2adm20CWNDxgI0XTAKcDQCdEogH
CWxKcyoitbzA40F0J1yDnfc=
=pQ3w
-----END PGP SIGNATURE-----

--==_Exmh_1173410393_8499P--
