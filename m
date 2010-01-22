Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839Ab0AVCQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab0AVCQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 21:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755818Ab0AVCQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 21:16:58 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:39210 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab0AVCQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 21:16:57 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, robert.richter@amd.com,
       oprofile-list@lists.sf.net
Subject: Re: [PATCH] Add Xeon 7500 series support to oprofile
In-Reply-To: Your message of "Thu, 21 Jan 2010 23:26:27 +0100."
             <20100121222627.GA22897@basil.fritz.box>
From: Valdis.Kletnieks@vt.edu
References: <20100121222627.GA22897@basil.fritz.box>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1264126458_4668P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 21 Jan 2010 21:14:18 -0500
Message-ID: <28939.1264126458@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=zidane.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020209.4B5909FC.016C,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1264126458_4668P
Content-Type: text/plain; charset=us-ascii

On Thu, 21 Jan 2010 23:26:27 +0100, Andi Kleen said:
> Add Xeon 7500 series support to oprofile
> 
> Straight forward: it's the same as Core i7, so just detect
> the model number. No user space changes needed.
> 
> Very simple patch, so it could be still merged for .33?
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  arch/x86/oprofile/nmi_int.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux/arch/x86/oprofile/nmi_int.c
> ===================================================================
> --- linux.orig/arch/x86/oprofile/nmi_int.c
> +++ linux/arch/x86/oprofile/nmi_int.c
> @@ -598,6 +598,7 @@ static int __init ppro_init(char **cpu_t
>  	case 15: case 23:
>  		*cpu_type = "i386/core_2";
>  		break;
> +	case 0x2e:
>  	case 26:
>  		spec = &op_arch_perfmon_spec;
>  		*cpu_type = "i386/core_i7";


I'll bite - why a hex constant rather than the decimal values nearby?

Also, should we do something about *cpu_type so it isn't confusing on a 7500
reporting itself as a i7?


--==_Exmh_1264126458_4668P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLWQn6cC3lWbTT17ARAhSKAKDn96SZuqDi+viTPAckG8/Y+77pBwCgneEL
1QQMO+8wXxdX839l25bs7Ys=
=sT68
-----END PGP SIGNATURE-----

--==_Exmh_1264126458_4668P--

