Return-Path: <linux-kernel-owner+w=401wt.eu-S1751803AbZJME1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803AbZJME1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 00:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbZJME1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 00:27:09 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:41350 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbZJME1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 00:27:08 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Oleg Nesterov <onestero@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [resend][PATCH v2] mlock() doesn't wait to finish lru_add_drain_all()
In-Reply-To: Your message of "Tue, 13 Oct 2009 10:17:48 +0900."
             <20091013090347.C752.A69D9226@jp.fujitsu.com>
From: Valdis.Kletnieks@vt.edu
References: <20091009111709.1291.A69D9226@jp.fujitsu.com> <20091012165747.97f5bd87.akpm@linux-foundation.org>
            <20091013090347.C752.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1255407959_3557P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 13 Oct 2009 00:25:59 -0400
Message-ID: <15231.1255407959@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.35.215 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020202.4AD40159.021B,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1255407959_3557P
Content-Type: text/plain; charset=us-ascii

On Tue, 13 Oct 2009 10:17:48 +0900, KOSAKI Motohiro said:

> > How did you work out why the lru_add_drain_all() is present in
> > sys_mlock() anyway?  Neither the code nor the original changelog tell
> > us.  Who do I thwap for that?  Nick and his reviewers.  Sigh.
> 
> [Umm, My dictionaly don't tell me the meaning of "thwap".  An meaning of
> an imitative word strongly depend on culture. Thus, I probably
> misunderstand this paragraph.]

http://ars.userfriendly.org/cartoons/?id=20030210&mode=classic

(biff, thwap, it's all the same - the sound of a cluebat impacting somebody ;)

--==_Exmh_1255407959_3557P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK1AFXcC3lWbTT17ARAoeQAKCYdCjq/kfHDCI2Rv34Pm9qNPVH7gCfXh0d
VHh8gS/i1yh4u1ksCJvnSnY=
=7xJN
-----END PGP SIGNATURE-----

--==_Exmh_1255407959_3557P--

