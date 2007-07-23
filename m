Return-Path: <linux-kernel-owner+w=401wt.eu-S933374AbXGWQjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374AbXGWQjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932907AbXGWQjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:39:09 -0400
Received: from net.mkgnu.net ([67.40.69.52]:61344 "EHLO mail.mkgnu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932831AbXGWQjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:39:06 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jul 2007 12:39:06 EDT
Subject: Dynamic kernel updates using DynAMOS
From: Kristis Makris <kristis.makris@asu.edu>
To: linux-kernel@vger.kernel.org, freebsd-hackers@freebsd.org,
       gnusol-devel@lists.sonic.net, opensolaris-code@opensolaris.org
Date: Mon, 23 Jul 2007 09:32:09 -0700
Message-Id: <1185208329.20434.23.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_morpheus-13872-1185208189-0001-2"
X-Mailer: Evolution 2.6.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_morpheus-13872-1185208189-0001-2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hello, please CC me as I'm not registered in these lists.

I'd like to announce DynAMOS, a dynamic kernel updating system that
supports Linux and could be of help in kernel development and high
availability.

This system has been a research project at Arizona State University
for the past 3 years and has finally become publicly available under
the GPL. Feedback would be very much appreciated.

It is an on-the-fly kernel updating system that enables commodity
operating systems to gain adaptive and mutative capabilities without
kernel recompilation or reboot. It employs a new dynamic
instrumentation technique called adaptive function cloning. Execution
flow can be switched adaptively among multiple editions of functions,
possibly concurrently running. This approach becomes the foundation
for dynamic replacement of non-quiescent kernel subsystems when the
timeliness of an update depends on synchronization of multiple kernel
paths.

This system can assist in kernel code prototyping and testing. It can
help fine-tune and benchmark live code (e.g. a scheduling policy) that
would otherwise require a full recompilation and reboot to adjust. It
can also be of help in long-lived systems that need to patch security
holes or benefit from new kernel features without downtime
(e.g. parallel computing clusters). A long-term goal is to automate
dynamically updating a live kernel from one version to the next.

Dynamic updates we've so far been able to carry out with DynAMOS
include:

o Extending the Linux 2.2 kernel process scheduler to support
   unobtrusive, fine-grain cycle stealing offered by the Linger-Longer
   system.

o Introducing adaptive memory paging for efficient gang-scheduling in
   a Linux 2.4 cluster.

o Adaptively updating the Linux pipefs implementation during large
   data transfers.

o Introducing kernel-assisted process checkpointing offered by EPCKPT
   in Linux 2.4.

o Applying security fixes provided by the Openwall project.

o Injecting performance monitoring functionality in kernel functions.

o Updating DynAMOS itself.


The current release is functional on Linux with ports to FreeBSD and
GNU OpenSolaris waiting for bugs to be ironed out. It builds with gcc
3.3 and 2.95, but not 4.x (yet). It comes with examples (e.g. update
get_pid(), update Linux 2.4 scheduler) of dynamic kernel updates for
people to easily try it out and comes prepackaged in .rpm and .deb for
Linux 2.4 (but not 2.2 or 2.6). The source distribution contains the
more complex updates mentioned above (adaptive updating, kernel
thread updates, checkpointing) and if compiled from source will work
for Linux versions 2.2-2.6.


People interested in learning more about the system can read:

o The project webpage:=20

   http://freshmeat.net/projects/dynamos/


o The current users manual:


http://files.mkgnu.net/files/dynamos/doc/latest_manual/html-single/manual.h=
tml


o A paper published in EuroSys '07 discussing the design and technical
   issues surrounding this work:

  http://files.mkgnu.net/files/dynamos/doc/papers/dynamos_eurosys_07.pdf


o A set of presentation slides that summarize the system:

  http://files.mkgnu.net/files/dynamos/doc/papers/dynamos_eurosys_07.ppt


I hope people will find this work useful and interesting enough for it
to continue being developed.

Thanks,
Kristis


--=_morpheus-13872-1185208189-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGpNgJ/KuTDwnYLxERAnz0AKCZBj0rJ+N46Acx1Sgkv00EEdOkEgCgnyM+
IfF+K1sc0CWROBTNKI97rEY=
=CF9/
-----END PGP SIGNATURE-----

--=_morpheus-13872-1185208189-0001-2--
