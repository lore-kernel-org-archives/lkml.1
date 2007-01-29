Return-Path: <linux-kernel-owner+w=401wt.eu-S932417AbXA2Kzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417AbXA2Kzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 05:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932834AbXA2Kzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 05:55:53 -0500
Received: from mivlgu.ru ([81.18.140.87]:35406 "EHLO master.mivlgu.local"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932417AbXA2Kzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 05:55:52 -0500
X-Greylist: delayed 1748 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jan 2007 05:55:51 EST
Date: Mon, 29 Jan 2007 13:26:41 +0300
From: Sergey Vlasov <vsu@altlinux.ru>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Soeren Sonnenburg <kernel@nn7.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] 2.6.20-rc6 pb_fnmode regression
Message-ID: <20070129102641.GC3375@master.mivlgu.local>
Mail-Followup-To: Jiri Kosina <jikos@jikos.cz>,
	Soeren Sonnenburg <kernel@nn7.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-usb-devel <linux-usb-devel@lists.sourceforge.net>
References: <1169904555.2462.10.camel@localhost> <Pine.LNX.4.64.0701291049190.9448@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tqI+Z3u+9OQ7kwn0"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701291049190.9448@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--tqI+Z3u+9OQ7kwn0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 29, 2007 at 10:55:48AM +0100, Jiri Kosina wrote:
> Changing module parameter values through sysfs is not a very nice idea,=
=20
> because the change of the value is indeed silent - the driver is not=20
> notified in any way, that the value has changed. So the driver should tak=
e=20
> care of it by itself, which is not a nice thing.

There is module_param_call() - used at least by drivers/md/md.c:

static int get_ro(char *buffer, struct kernel_param *kp)
=2E..
static int set_ro(const char *val, struct kernel_param *kp)
=2E..
module_param_call(start_ro, set_ro, get_ro, NULL, S_IRUSR|S_IWUSR);

--tqI+Z3u+9OQ7kwn0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFFvcvhW82GfkQfsqIRAq/0AJ40A/Wfpas3BaBwROM+Z0ysKDbxMgCcD/7L
Hxw+f5j+PKRcGx+WxyD0Tno=
=Awbf
-----END PGP SIGNATURE-----

--tqI+Z3u+9OQ7kwn0--
