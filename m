Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab0BLSgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 13:36:20 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:34898 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab0BLSgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 13:36:19 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 06/12] Add /proc trigger for memory compaction
In-Reply-To: Your message of "Fri, 12 Feb 2010 12:00:53 GMT."
             <1265976059-7459-7-git-send-email-mel@csn.ul.ie>
From: Valdis.Kletnieks@vt.edu
References: <1265976059-7459-1-git-send-email-mel@csn.ul.ie>
            <1265976059-7459-7-git-send-email-mel@csn.ul.ie>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1265999680_4070P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 12 Feb 2010 13:34:40 -0500
Message-ID: <7691.1265999680@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020203.4B759F41.00E1,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1265999680_4070P
Content-Type: text/plain; charset=us-ascii

On Fri, 12 Feb 2010 12:00:53 GMT, Mel Gorman said:
> This patch adds a proc file /proc/sys/vm/compact_memory. When an arbitrary
> value is written to the file, all zones are compacted. The expected user
> of such a trigger is a job scheduler that prepares the system before the
> target application runs.

Argh. A global trigger in /proc, and a per-node trigger in /sys too.  Can we
get by with just one or the other?  Should the /proc one live in /sys too?


--==_Exmh_1265999680_4070P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLdZ9AcC3lWbTT17ARAuqMAJ9zE7Mlw+qy2dVG4qMLTgAviVaRlgCfTdBT
MFUCALw++Nh/mf9587aU584=
=J6gQ
-----END PGP SIGNATURE-----

--==_Exmh_1265999680_4070P--

