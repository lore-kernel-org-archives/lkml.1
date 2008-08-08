Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942AbYHHAv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbYHHAv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 20:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbYHHAvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 20:51:50 -0400
Received: from nihrelayxway2.hub.nih.gov ([128.231.90.107]:15448 "EHLO
	nihrelayxway2.hub.nih.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbYHHAvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 20:51:49 -0400
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Aug 2008 20:51:49 EDT
X-IronPortListener: NIH_Relay
X-SBRS: None
X-IronPort-AV: E=Sophos;i="4.31,323,1215403200"; 
   d="scan'208";a="32117267"
From: Charles@schwieters.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Charles@schwieters.org, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: resume problem with i915/drm 
In-reply-to: <200808072208.05887.rjw@sisk.pl> 
References: <E1KQYiX-0002Nl-Ud@oaf.wireless> <200808072208.05887.rjw@sisk.pl>
Comments: In-reply-to "Rafael J. Wysocki" <rjw@sisk.pl>
   message dated "Thu, 07 Aug 2008 22:08:05 +0200."
X-Mailer: MH-E 8.0.3; nmh 1.2; GNU Emacs 22.2.1
Date: Thu, 07 Aug 2008 20:42:05 -0400
Message-Id: <E1KRG3R-0002NL-DI@tan.cit.nih.gov>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (cake.cit.nih.gov [165.112.93.31]); Thu, 07 Aug 2008 20:42:06 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


Hi Folks--

  I'm a moron. It turns out that CONFIG_ACPI_VIDEO had come unset when
CONFIG_VIDEO_OUTPUT_CONTROL came into existence (sometime after 2.6.17)
- - through my use of make oldconfig. Resume works fine with 2.6.26.1 if I
re-enable these. The i915/drm module unload warning message does seem to
be real, but perhaps unrelated to resume. 

thanks for your earnest responses--

Charles
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Processed by Mailcrypt 3.5.8+ <http://mailcrypt.sourceforge.net/>

iD8DBQFIm5ZdPK2zrJwS/lYRAnOFAJ9ygKd3rBTqWZy3+aMSw9p+hYX2iQCdEe3t
Qhwle4QF+Torx/aA/ZNgJqI=
=64VA
-----END PGP SIGNATURE-----
