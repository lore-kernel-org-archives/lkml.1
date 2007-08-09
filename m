Return-Path: <linux-kernel-owner+w=401wt.eu-S936632AbXHIJ77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936632AbXHIJ77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 05:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbXHIJ7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 05:59:51 -0400
Received: from canadatux.org ([85.214.62.144]:60246 "EHLO
	zoidberg.canadatux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbXHIJ7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 05:59:50 -0400
Date: Thu, 9 Aug 2007 11:59:43 +0200
From: Matthias Hensler <matthias@wspse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Processes spinning forever, apparently in lock_timer_base()?
Message-ID: <20070809095943.GA7763@kobayashi-maru.wspse.de>
Reply-To: Matthias Hensler <matthias@wspse.de>
References: <46B10BB7.60900@redhat.com> <20070803113407.0b04d44e.akpm@linux-foundation.org> <20070804084426.GA20464@kobayashi-maru.wspse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <20070804084426.GA20464@kobayashi-maru.wspse.de>
Organization: WSPse (http://www.wspse.de/)
X-Gummibears: Bouncing here and there and everywhere
X-Face: &Tv]9SsNpb/$w8\G-O%>W02aApFW^P>[x+Upv9xQB!2;iD9Y1-Lz'qlc{+lL2Y>J(u76 Jk,cJ@$tP2-M%y?^'jn2J]3C'ss_~"u?kA^X&{]h?O?@*VwgSGob73I9r}&S%ktup0k2 !neScg3'HO}PU#Ac>jwNL|P@f|f*sz*cP'hi)/<JQC4|Q[$D@aQ"C{$>a=6.rc-P1vXa rjVXlzClmNfcSy/$4tQz
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline

On Sat, Aug 04, 2007 at 10:44:26AM +0200, Matthias Hensler wrote:
> On Fri, Aug 03, 2007 at 11:34:07AM -0700, Andrew Morton wrote:
> [...]
> I am also willing to try the patch posted by Richard.

I want to give some update here:

1. We finally hit the problem on a third system, with a total different
   setup and hardware. However, again high I/O load caused the problem
   and the affected filesystems were mounted with noatime.

2. I installed a recompiled kernel with just the two line patch from
   Richard Kennedy (http://lkml.org/lkml/2007/8/2/89). That system has 5
   days uptime now and counting. I believe the patch fixed the problem.
   However, I will continue running "vmstat 1" and the endless loop of
   "cat /proc/meminfo", just in case I am wrong.

Regards,
Matthias

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUBRrrliYagCBsispUdAQLE/QQAjIHZ0tHNPsHemw+F0lrMcOjCP/aFVxzN
ARVZvT0DSH/QosrsC3Bjwe+DoleRBEdqGsNGiOr18IKBFRNWsficYxVvUyCHAJBL
7SrxCfN/Uba825d1/vM9bEI6HtQZJtuTUX+AKEQzjba/4nJdfET06lxT3gEKE78c
eOnQW4mrhPI=
=nlQq
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
