Return-Path: <linux-kernel-owner+w=401wt.eu-S936488AbYGCHOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936488AbYGCHOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755041AbYGCG6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:58:48 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:55092 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356AbYGCGgb (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 02:36:31 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Intel Microcode loader, tg3 driver, and the -rc8-mmotd New World Order firmware...
In-Reply-To: Your message of "Thu, 03 Jul 2008 07:17:16 BST."
             <Pine.LNX.4.61.0807030716030.10434@ginsburg.homenet>
From: Valdis.Kletnieks@vt.edu
References: <4534.1215048758@turing-police.cc.vt.edu>
            <Pine.LNX.4.61.0807030716030.10434@ginsburg.homenet>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1215066946_4193P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 03 Jul 2008 02:35:47 -0400
Message-ID: <32146.1215066947@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1215066946_4193P
Content-Type: text/plain; charset=us-ascii

On Thu, 03 Jul 2008 07:17:16 BST, Tigran Aivazian said:
> Hi Valdis,
> 
> On Wed, 2 Jul 2008 Valdis.Kletnieks@vt.edu wrote:
> 
> > I built the -rc8-mmotd kernel, and built it with 'CONFIG_FIRMWARE_IN_KERNEL
=n'.
> > Lo and behold, the microcode.ko was now doing a request_firmware for
> > 'intel-ucode/06-0f-06' (which makes sense, the Core2 Duo in this laptop is
> > family 6, model 15, stepping 6).  However, what I had in /lib/firmware was
> > the Intel-distributed 'microcode.dat' with updates for all the CPUs (which
> > used to work in times past).
> >
> > What's the magic incantation to take the microcode.dat and create something
> > that the firmware driver is willing to use, or is this all borked up and
> > I need to do a major rethink or fix my config?
> 
> that's because it expects the Intel-supplied microcode data and you are 
> using the old style microcode.dat data.

I fed it the stuff I downloaded today from this URL:

http://downloadcenter.intel.com/filter_results.aspx?strTypes=all&ProductID=2643&OSFullName=Linux*&lang=eng&strOSs=39&submit=Go!

which gets me a microcode-20080401.dat that does the same thing.  Is there
some *other* Intel-supplied microcode data I should be getting instead?

(If I should be looking elsewhere, can somebody fix http://www.urbanmyth.org/microcode/
to point somewhere other than http://downloadcenter.intel.com/default.aspx so
people go to the right place?)
> 
> Kind regards
> Tigran
> 
> >
> > Another minor annoyance - the tg3 driver, when builtin to the kernel, would
n't
> > load the microcode in this config. It complained it couldn't get 'tigon/tg3
_tos.bin',
> > but that's almost certainly an issue with Fedora's 'nash' firmware support 
and/or
> > my understanding of it - I got *that* part working by dropping the file int
o
> > /lib/firmware/tigon and building the driver as a module. Fortunately, I don
't
> > need the tg3 driver to boot far enough to get a full udev running.
> >
> >
> 


--==_Exmh_1215066946_4193P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIbHNCcC3lWbTT17ARAmGuAJ0YJmIMv8ncV17cux3jYXFXb8uxOgCg7yzh
JBsnSv97rUVd+7RW7J0myjw=
=3m+r
-----END PGP SIGNATURE-----

--==_Exmh_1215066946_4193P--
