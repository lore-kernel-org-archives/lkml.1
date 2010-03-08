Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab0CHBl5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 20:41:57 -0500
Received: from LION.seas.upenn.edu ([158.130.12.194]:36995 "EHLO
	lion.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab0CHBlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 20:41:52 -0500
X-Greylist: delayed 432 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Mar 2010 20:41:52 EST
Message-ID: <4B9455D2.7080502@seas.upenn.edu>
Date: Sun, 07 Mar 2010 20:41:38 -0500
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Micki Balanga <micki@n-trig.com>
CC: jkosina@suse.cz, chatty@enac.fr, peterhuewe@gmx.de,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Rafi Rubin <rafi@seas.upenn.edu>
Subject: Re: [PATCH] USB: N-trig Finger Pen Multitouch fix
References: <48A28051AC6D7A48B64F28272458190301AF29@Exchange-IL.n-trig.com>
In-Reply-To: <48A28051AC6D7A48B64F28272458190301AF29@Exchange-IL.n-trig.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

One other note:

> +                                               input_report_abs(input,
> ABS_MT_TRACKING_ID, nt_rpt->finger_id);

I pulled the tracking id to conform to
	Documentation/input/multi-touch-protocol.txt
which states that unreliable tracking ids should not be passed to the user
space.  So unless you have done something to fix the broken tracking that I've
been seeing, we should leave it out for now.

Rafi
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkuUVdIACgkQwuRiAT9o608ymwCgpGXXnsWcEd2C+WaBxVpnla/e
xYgAoK68Yyvl2RLzqhWVGk9tKOFpsEwI
=O+8/
-----END PGP SIGNATURE-----
