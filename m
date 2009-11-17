Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbZKQSt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbZKQSt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 13:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754289AbZKQSt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 13:49:59 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:42404 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbZKQSt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 13:49:58 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: William Allen Simpson <william.allen.simpson@gmail.com>
Cc: huananhu@huawei.com, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/11]Optimize the upload speed for PPP connection.
In-Reply-To: Your message of "Tue, 17 Nov 2009 05:20:09 EST."
             <4B0278D9.6030806@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <faf197be196ee.196eefaf197be@huawei.com> <20091117.012248.86306050.davem@davemloft.net>
            <4B0278D9.6030806@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1258483787_3145P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 17 Nov 2009 13:49:47 -0500
Message-ID: <13129.1258483787@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.14.107 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020209.4B02F04B.00D0,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1258483787_3145P
Content-Type: text/plain; charset=us-ascii

On Tue, 17 Nov 2009 05:20:09 EST, William Allen Simpson said:

> And your trailer boilerplate badly breaks the system, because it's
> missing the SMTP email standard "--" line in front of it.

Ahem.

It's not an 'SMTP standard' - in fact, SMTP doesn't even care diddly about the
user-visible *headers* in the mail, much less what the convention for a
signature block is.  If you get EHLO, MAIL FROM, RCPT TO, DATA, '.', and QUIT,
that's 95% of SMTP right there.  And none of it where normal users can even see
it (though the MAIL FROM can show up as Return-Path: sometimes).

The '-- ' *convention* isn't even at the next layer up, MIME.  If anything,
it's out at the liveware level (though some MUAs provide code to make it
a bit easier to deal with...)

(Feel free to cite RFC chapter-and-verse if you disagree, and note that
'Informational' RFCs are never standards. ;)


--==_Exmh_1258483787_3145P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLAvBLcC3lWbTT17ARAh4gAJ0UgrRzYglUYi7BUvV0tJBgMqvInQCg96oH
aHc4tK9YfM0wvn2Qct92I8k=
=yer/
-----END PGP SIGNATURE-----

--==_Exmh_1258483787_3145P--

