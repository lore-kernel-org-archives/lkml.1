Return-Path: <linux-kernel-owner+w=401wt.eu-S1759920AbYBOV4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920AbYBOV4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 16:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758880AbYBOV4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 16:56:08 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:52873 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758826AbYBOV4H (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 16:56:07 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Linda Walsh <lkml@tlinx.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86-32-config: why is pc-speaker an input device?
In-Reply-To: Your message of "Fri, 15 Feb 2008 13:19:11 PST."
             <47B601CF.9070300@tlinx.org>
From: Valdis.Kletnieks@vt.edu
References: <47B601CF.9070300@tlinx.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1203112503_2934P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 15 Feb 2008 16:55:03 -0500
Message-ID: <4387.1203112503@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1203112503_2934P
Content-Type: text/plain; charset=us-ascii

On Fri, 15 Feb 2008 13:19:11 PST, Linda Walsh said:
> I'm wondering how the generic, builtin PC-Speaker (config option
> "INPUT_PCSPKR") can be used as an input device.
> 
> If it can not be used for input, why is it under the input config section:
> 
> "Device Drivers"
> + -> "Input Device Support"
>      + -> "Miscellaneous devices"
>          + -> "PC Speaker Support"
> 
> When booting, it is "enumerated" as an input device: (from dmesg)
> 
>   input: PC Speaker as /devices/platform/pcspkr/input/input2
> 
> Just trying to figure out the rationale behind the choice...

The last time around for this question, I was half-paying attention, and
the rationale sounded like "We had an input device framework, no output
device framework, and too many bad shrooms to do something comprehensible".

(This is such a *frequent* FAQ, even all the time since 2.6.0 escaped, that
maybe we need to add a 3-4 line explain to the Kconfig 'help' stanza for
CONFIG_INPUT_PCSPKR - although for some reason, INPUT_SPARCSPKR and
INPUT_M68K_BEEP don't seem to cause the same questions....)


--==_Exmh_1203112503_2934P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHtgo3cC3lWbTT17ARArA8AJ9UeBm9ubbTME8QxvUmEEf+0WCcrACfdFLL
2wiwDAy+kCDdkqssCgYGAr0=
=fqql
-----END PGP SIGNATURE-----

--==_Exmh_1203112503_2934P--
