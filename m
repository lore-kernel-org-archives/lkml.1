Return-Path: <linux-kernel-owner+w=401wt.eu-S1751648AbZKOXTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbZKOXTS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 18:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbZKOXTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 18:19:17 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:43684 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444AbZKOXTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 18:19:17 -0500
X-Greylist: delayed 617 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Nov 2009 18:19:17 EST
Message-ID: <4B008A22.80909@metafoo.de>
Date: Mon, 16 Nov 2009 00:09:22 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: pcf50633 - fix error handling during probe
References: <20091109092447.29634.79364.stgit@localhost.localdomain> <20091109092516.29634.32640.stgit@localhost.localdomain>
In-Reply-To: <20091109092516.29634.32640.stgit@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Dmitry Torokhov wrote:
> The pcf50633 is very naive - it assumes that all driver core
> operations will succeed and will fail badly if one of them
> errors out. Implement proper error handling and make sure we
> release any and all resources that have been allocated prior
> to failure.
>
> Also avoid memory leak when using platform_device_add_data()
> which clones the supplied data structure for use by the device.
> The original copy, if allocated dynamically, needs to be freed
> by the caller; switch to using on-stack variable (the size of
> the structure in question is quite small) instead.
>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Hi

Most of the issues addressed in this patch have already been fixed.
Please check the for-next branch in the mfd tree.

- - Lars
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAksAiiIACgkQBX4mSR26RiNJbACfYs4UhLSrlYuNqynJ/Mguw+oj
FxQAn2xmUh8QZttY4jxKUsdg+6p/pXNT
=yCtL
-----END PGP SIGNATURE-----

