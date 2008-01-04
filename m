Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbYADU0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbYADU0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 15:26:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYADU0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 15:26:23 -0500
Received: from os.inf.tu-dresden.de ([141.76.48.99]:36361 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbYADU0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 15:26:22 -0500
X-Greylist: delayed 3019 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Jan 2008 15:26:22 EST
Date: Fri, 4 Jan 2008 20:35:58 +0100
From: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>
To: linux-kernel@vger.kernel.org
Subject: Re: memory remapping, 4gb memory on 945gt
Message-ID: <20080104203558.73dd04a4@laptop.hypervisor.org>
In-Reply-To: <p73lk758sri.fsf@bingen.suse.de>
References: <20080104154914.GA589@codeblau.de>
	<p73lk758sri.fsf@bingen.suse.de>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Ex7QAu_JoH+Pa0/=dKCyhGP";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Ex7QAu_JoH+Pa0/=dKCyhGP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 04 Jan 2008 17:22:57 +0100 Andi Kleen (AK) wrote:

AK> felix-linuxkernel@fefe.de writes:
AK>=20
AK> > I recently put 4 GB of memory in my Acer Travelmate 8210 series
AK> > notebook.  The BIOS only detects 3 GB.
AK>=20
AK> Actually it will detect 4GB, but put the PCI hole over the last GB.
AK> One way to get more usable memory is to configure the BIOS to use a
AK> smaller PCI hole (e.g. use smaller frame buffer/aperture etc.)
AK>=20
AK> > I googled around a little.  It appears to be a chipset limitation of
AK> > the 945gt, which uses the fourth gig for devices.
AK> >
AK> > Now I can understand this explanation for 32-bit mode, but I'm running
AK> > in 64-bit mode.  There should be a way to use the fourth gig under
AK> > Linux.  Is there?
AK>=20
AK> The chipset limitation applies to 64bit mode as well as to 32bit mode
AK> (which actually does not have a 4GB limitation with PAE)

Using a 64-bit or PAE kernel won't give access to more than 4GB of RAM
because that only increases the linear address space of the CPU to 48 or
36 bits respectively. The limitation with 945GT is that the chipset only
supports 32-bit physical addresses. As Andi already pointed out, parts of
that 4GB physical address space are used by devices and their apertures,
so you can only try to shrink those devices ranges, if configurable, but
you won't be able to use the full 4GB RAM.

Cheers,

	- Udo

--Sig_/Ex7QAu_JoH+Pa0/=dKCyhGP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHfoqenhRzXSM7nSkRAvnTAJ4n69TFPwF8kAHel/PdG7ZTM1pJ8QCfZ504
DofO1GiYXpNL31I6y2+XsH0=
=hcLQ
-----END PGP SIGNATURE-----

--Sig_/Ex7QAu_JoH+Pa0/=dKCyhGP--
