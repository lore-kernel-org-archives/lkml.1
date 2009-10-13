Return-Path: <linux-kernel-owner+w=401wt.eu-S1760096AbZJMO50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096AbZJMO50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759670AbZJMO50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:57:26 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:36029 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758721AbZJMO5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:57:25 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Herbert Poetzl <herbert@13thfloor.at>, vatsa@in.ibm.com,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v2 PATCH 0/8] CFS Hard limits - v2
In-Reply-To: Your message of "Tue, 13 Oct 2009 16:19:41 +0400."
             <4AD4705D.6020109@openvz.org>
From: Valdis.Kletnieks@vt.edu
References: <20090930124919.GA19951@in.ibm.com> <4AC35EDD.1080902@openvz.org> <20090930142537.GJ19951@in.ibm.com> <20090930143953.GA2014@in.ibm.com> <4AD466E5.4010206@openvz.org> <20091013120354.GF24787@MAIL.13thfloor.at>
            <4AD4705D.6020109@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1255445760_3097P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 13 Oct 2009 10:56:00 -0400
Message-ID: <4906.1255445760@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.14.107 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020202.4AD49501.009E,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1255445760_3097P
Content-Type: text/plain; charset=us-ascii

On Tue, 13 Oct 2009 16:19:41 +0400, Pavel Emelyanov said:

> >   with 50%, you get 1s/0.5s
> >   with 20%, you get 1s/0.2s
> >   with  5%, you get 1s/0.05s
> > 
> > well, you get the idea :)
> 
> No I don't.
> Is 1s/0.5s worse or better than 2s/1s?
> How should I make a choice?

It depends how sensitive you want to be to short bursts of CPU usage.

And of course, if we're going down that route, I'll point out that over in
the network world, 95% percentile billing is pretty popular.  How to do it
in this application, I have not a clue. ;)

http://en.wikipedia.org/wiki/Burstable_billing

--==_Exmh_1255445760_3097P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK1JUAcC3lWbTT17ARApoJAKCc/qiRsyBiEjROl21lNpLe1mPk3QCgiVx4
G/6dvU82BMIBOGogyNCIw0g=
=N46y
-----END PGP SIGNATURE-----

--==_Exmh_1255445760_3097P--

