Return-Path: <linux-kernel-owner+w=401wt.eu-S933836AbXCSMgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933836AbXCSMgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 08:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933832AbXCSMgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 08:36:46 -0400
Received: from ganymede.vroon.org ([195.66.242.11]:42473 "EHLO
	ganymede.vroon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933238AbXCSMgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 08:36:45 -0400
X-Greylist: delayed 1387 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Mar 2007 08:36:44 EDT
Message-ID: <45FE7E44.6040805@gentoo.org>
Date: Mon, 19 Mar 2007 12:12:52 +0000
From: Tony Vroon <chainsaw@gentoo.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.22] Add LED trigger to libata core
References: <20070318170605.3751D5B80F1@ganymede.vroon.org>	<45FE14BD.5090701@gmail.com> <20070319124616.2fb7494b@lxorguk.ukuu.org.uk>
In-Reply-To: <20070319124616.2fb7494b@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Alan Cox wrote:
> Gak. I'd rather it stayed out of ata_qc_issue() which is a critical path
> for performance. Our command issu is already too heavy and not all
> controllers have queueing to absorb that. How many controllers actually
> need this hook and can we not have ata_qc_issue_with_led() helpers for
> them ?
We're talking about just sata_svw (Apple K2) right now. I'll have a go
at implementing it conditionally like you suggested. Consider the
patch withdrawn for now.

Regards,
Tony V.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF/n5Dp5vW4rUFj5oRCJbzAJ4+rkkqdA21If03WLFT6jquX+np+QCgwSGX
UV41rt4ZimQvf0kXLwkuFqo=
=Ar6p
-----END PGP SIGNATURE-----

