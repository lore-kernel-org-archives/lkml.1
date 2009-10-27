Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbZJ0TfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbZJ0TfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 15:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756715AbZJ0TfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 15:35:10 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:59900 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756642AbZJ0TfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 15:35:09 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2 0
In-Reply-To: Your message of "Tue, 27 Oct 2009 12:07:34 PDT."
             <4AE744F6.5050801@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <4AE24009.4090408@gmail.com> <dd18b0c30910261134s76274dbbj9c1904e78c2b5a38@mail.gmail.com> <21504.1256588976@turing-police.cc.vt.edu> <4AE611B2.1030409@gmail.com> <29209.1256624599@turing-police.cc.vt.edu>
            <4AE744F6.5050801@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1256672113_3649P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 27 Oct 2009 15:35:13 -0400
Message-ID: <22388.1256672113@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.14.107 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020202.4AE74B71.005A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1256672113_3649P
Content-Type: text/plain; charset=us-ascii

On Tue, 27 Oct 2009 12:07:34 PDT, "Justin P. Mattock" said:

> The results are similar with the messages, except
> with the curly's the system will panic the same as above
> and not boot.

As I expected - I explained why already.  And in fact, I intentionally did
that, so that the *last* one of those added messages before your panic
will output the info regarding the device that caused it (hacking around
the panic would mean that you'd get a whole bunch of messages and not have
an easy way to tell *which one* caused the now-bypassed issue...)

> (So I guess it was good to forget the curly's
> to some extent).

So out of curiosity, what did the messages actually *SAY*?  They should
be pointing at the device that's giving your system indigestion, so it's
useful to actually include the output (I didn't pull that printk format
string out of thin air.. ;)


--==_Exmh_1256672113_3649P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK50txcC3lWbTT17ARApI9AKDGU5tJNNTjQV2hA5wpvwr6jqUSLQCeMQRm
iFr50Z9jGas4+3nXF7UfAhA=
=VYOC
-----END PGP SIGNATURE-----

--==_Exmh_1256672113_3649P--

