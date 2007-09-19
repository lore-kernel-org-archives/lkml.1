Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbXISU0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbXISU0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 16:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbXISU0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 16:26:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33600 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbXISU0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 16:26:36 -0400
Message-ID: <46F156A7.5000304@redhat.com>
Date: Wed, 19 Sep 2007 10:04:39 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: follow-up: discrepancy with POSIX
References: <46F13E8B.4050309@redhat.com>	<p73sl5aveqh.fsf@bingen.suse.de>	<46F15305.2030507@redhat.com> <20070919.095251.45154496.davem@davemloft.net>
In-Reply-To: <20070919.095251.45154496.davem@davemloft.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

David Miller wrote:
> It just occured to me that AF_UNSPEC might be used simply
> because "all zeros" might be a valid real bindable address
> for some address family.  And using AF_UNSPEC avoids that
> problem entirely.

Yes, but for IPv4/6 it's not an issue.  Some implementations might
handle all-zeros and the spec _currently_ calls for it.  In this case an
alignment would be good.

I guess I'll just go ahead and file a problem report with the spec.
Maybe the Unix vendors will test their implementations in provide feedback.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFG8Vam2ijCOnn/RHQRAlw2AJwPCkD/GdX5YWCjsidhNXkGT71SiQCeLUDX
XimSWS2NMI9T8QxnnV3FDQ4=
=8XbG
-----END PGP SIGNATURE-----
