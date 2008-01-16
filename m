Return-Path: <linux-kernel-owner+w=401wt.eu-S1753441AbYAPJbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbYAPJbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 04:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbYAPJbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 04:31:14 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:58100 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbYAPJbN (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 04:31:13 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Greg KH <greg@kroah.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH]PCIE ASPM support - takes 2
In-Reply-To: Your message of "Wed, 16 Jan 2008 13:26:14 +0800."
             <1200461174.26885.4.camel@sli10-desk.sh.intel.com>
From: Valdis.Kletnieks@vt.edu
References: <1200373346.20739.4.camel@sli10-desk.sh.intel.com> <24456.1200455812@turing-police.cc.vt.edu>
            <1200461174.26885.4.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1200475868_2966P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 16 Jan 2008 04:31:08 -0500
Message-ID: <7566.1200475868@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1200475868_2966P
Content-Type: text/plain; charset=us-ascii

On Wed, 16 Jan 2008 13:26:14 +0800, Shaohua Li said:
> On Tue, 2008-01-15 at 22:56 -0500, Valdis.Kletnieks@vt.edu wrote:
> > Do you have any numbers on what the added latency is for powersave mode, and
> > a rough idea of how quickly chipsets will drop to low-power? It may affect
> > usability a lot if it's "adds 10ms latency after 100ms idle" or "adds 100ms
> > latency after 5 seconds idle" or some other pattern...
> >
> > (The chipset in my laptop claims to be an 82801G with 4 PCI-Express ports on
> > it - I'm trying to get a rough idea what usage I'd get out of that feature..)
> No, I thought to get the latency impact with ASPM enabled, but haven't
> found a way to measure it. This is why the default setting of ASPM
> currently is using BIOS setting.

It's OK - I spent some time staring at the output of 'lspci -t' on this laptop,
and convinced myself that the numbers won't matter that much - of the 4 PCIE
ports alledged to be there, 2 aren't connected to anything, and the other 2 are
network (a tg3 and an intel 3945) - and those two are both either (depending
where I am) "essentially idle and will almost certainly sleep" or "busy enough
they likely won't sleep no matter *what* the numbers are".

(That's assuming the chipset in question even *does* ASPM - but it wouldn't be
the first time I've tested stuff just to make sure it didn't enable an impossible
hardware option.. ;)


--==_Exmh_1200475868_2966P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHjc7ccC3lWbTT17ARArKIAJ9cFBiTtsT6CrYRyFM+Io3ApT15hACg5m2J
ki/Be+0NiTpsJV1YZkB6z/w=
=DKxl
-----END PGP SIGNATURE-----

--==_Exmh_1200475868_2966P--
