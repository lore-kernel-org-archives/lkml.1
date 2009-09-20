Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbZITUUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbZITUUZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 16:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbZITUUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 16:20:24 -0400
Received: from c-71-63-93-204.hsd1.va.comcast.net ([71.63.93.204]:45437 "EHLO
	c-71-63-93-204.hsd1.va.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828AbZITUUY (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 16:20:24 -0400
X-Greylist: delayed 3574 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Sep 2009 16:20:24 EDT
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Beth Kon <eak@us.ibm.com>, rostedt@goodmis.org, avi@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Wierdness - linux-next KVM patch breaks Dell Latitude D820, KVM not in kernel
In-Reply-To: Your message of "Mon, 07 Sep 2009 10:07:07 EDT."
             <3850.1252332427@turing-police.cc.vt.edu>
From: Valdis.Kletnieks@vt.edu
References: <3850.1252332427@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1253461809_2954P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 20 Sep 2009 11:50:09 -0400
Message-ID: <77690.1253461809@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1253461809_2954P
Content-Type: text/plain; charset=us-ascii

On Mon, 07 Sep 2009 10:07:07 EDT, Valdis.Kletnieks@vt.edu said:

> Symptoms: Dell Latitude D820 either hangs at very early boot (before
> any output, not even penguins), or (apparently) triple-faults into an
> immediate reboot.  linux-2.6.31-rc7-mmotm0827 works fine, so whatever the
> real issue is, it hit linux-next between then and when Andrew pulled for
> -0902.  Since I was feeling lazy, I told 'git bisect' that 2.6.31-rc7 was
> good and HEAD was bad.

Whatever it was, I can no longer replicate it with 2.6.31-mmotm0917, so it
looks like some maintainer merged the fix for whatever it was.  File
this one under "things that go bump in the night", I guess...

--==_Exmh_1253461809_2954P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKtk8xcC3lWbTT17ARAmBaAJ9dab0iVs5B9CaqXOmB3mnGCrsZKQCfXqEY
Phr3ZkfXYx391CDgOb6gp38=
=drci
-----END PGP SIGNATURE-----

--==_Exmh_1253461809_2954P--
