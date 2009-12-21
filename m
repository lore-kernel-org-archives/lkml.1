Return-Path: <linux-kernel-owner+w=401wt.eu-S1757171AbZLUUlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171AbZLUUlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 15:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757156AbZLUUlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 15:41:44 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:49944 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757114AbZLUUln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 15:41:43 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joe@perches.com, torvalds@linux-foundation.org, peterz@infradead.org,
       efault@gmx.de, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched: Restore printk sanity
In-Reply-To: Your message of "Sun, 20 Dec 2009 18:00:38 GMT."
             <tip-6c9a74afc5d95321e33a727b3c563f3e7d6c4a5c@git.kernel.org>
From: Valdis.Kletnieks@vt.edu
References: <1261315437.4314.6.camel@laptop>
            <tip-6c9a74afc5d95321e33a727b3c563f3e7d6c4a5c@git.kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1261428024_3965P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 21 Dec 2009 15:40:24 -0500
Message-ID: <25268.1261428024@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A02020A.4B2FDD38.027A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1261428024_3965P
Content-Type: text/plain; charset=us-ascii

On Sun, 20 Dec 2009 18:00:38 GMT, tip-bot for Peter Zijlstra said:
> Commit-ID:  6c9a74afc5d95321e33a727b3c563f3e7d6c4a5c

> @@ -7828,44 +7828,48 @@ static int sched_domain_debug_one(struct sched_domain
 *sd, int cpu, int level,
>  	printk(KERN_DEBUG "%*s domain %d: ", level, "", level);
>  
>  	if (!(sd->flags & SD_LOAD_BALANCE)) {
> -		pr_cont("does not load-balance\n");
> +		printk("does not load-balance\n");

printk(KERN_CONT  perhaps?




--==_Exmh_1261428024_3965P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLL904cC3lWbTT17ARAgJCAJ40ue3KUhZNmaVeQwFZgjdmCu8zhwCeIfzo
uXsb/g/08NET2MdbFg7D2ts=
=grAF
-----END PGP SIGNATURE-----

--==_Exmh_1261428024_3965P--

