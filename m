Return-Path: <linux-kernel-owner+w=401wt.eu-S1757695AbXL3Q3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695AbXL3Q3Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 11:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbXL3Q3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 11:29:07 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:36738 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbXL3Q3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 11:29:05 -0500
Message-ID: <4777C745.8080700@kernel.org>
Date: Sun, 30 Dec 2007 08:28:53 -0800
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: KaiGai Kohei <kaigai@ak.jp.nec.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, jmorris@namei.org, akpm@osdl.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Exporting capability code/name pairs
References: <477321C8.3070004@ak.jp.nec.com> <20071227161435.GB9677@sergelap.austin.ibm.com> <477455A0.7060603@ak.jp.nec.com> <477494C3.2040301@ak.jp.nec.com>
In-Reply-To: <477494C3.2040301@ak.jp.nec.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

KaiGai Kohei wrote:
> Remaining issues:
> - We have to mount securityfs explicitly, or use /etc/fstab.
>   It can cause a matter when we want to use this feature on
>   very early phase on boot. (like /sbin/init)

I'm not altogether clear how you intend this to work.

Are you saying that some future version of libcap will require that
securityfs be mounted before it (libcap) will work?

Thanks

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHd8dE+bHCR3gb8jsRAurnAJ4t5GKckQVj4Xr1JeTjoowUniU2jACgr5V8
3D3zbx5PkrVTRaYay6ZwJSc=
=D2ZM
-----END PGP SIGNATURE-----
