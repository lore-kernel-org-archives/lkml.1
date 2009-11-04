Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbZKDMdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbZKDMdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 07:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbZKDMdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 07:33:42 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:45946 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879AbZKDMdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 07:33:41 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Ingo Molnar <mingo@elte.hu>
Cc: Aristeu Rozanski <aris@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: introduce NMI_AUTO as nmi_watchdog option
In-Reply-To: Your message of "Wed, 04 Nov 2009 12:46:30 +0100."
             <20091104114630.GA16993@elte.hu>
From: Valdis.Kletnieks@vt.edu
References: <20091103171054.GB25437@redhat.com>
            <20091104114630.GA16993@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1257337997_3003P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Nov 2009 07:33:17 -0500
Message-ID: <38974.1257337997@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.34.98 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4AF1748E.0289,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1257337997_3003P
Content-Type: text/plain; charset=us-ascii

On Wed, 04 Nov 2009 12:46:30 +0100, Ingo Molnar said:
> What i'd like to see for the NMI watchdog is much more ambitious than 
> this: the use of perf events to run a periodic NMI callback.
> 
> The NMI watchdog would cause the creation of a per-cpu perf_event 
> structure (in-kernel). All x86 CPUs that have perf event support (the 
> majority of them) will thus be able to have an NMI watchdog using a 
> nice, generic piece of code and we'd be able to phase out the open-coded 
> NMI watchdog code.

What happens on older/smaller x86 CPUs that don't have any native support
for perf events?

--==_Exmh_1257337997_3003P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK8XSNcC3lWbTT17ARApbXAKDNn9BL4mFlbsYw3zIHrL+i/RJPWgCdGfm1
sWDJMnReC0qjlaxbjj/u2xs=
=KDhg
-----END PGP SIGNATURE-----

--==_Exmh_1257337997_3003P--

