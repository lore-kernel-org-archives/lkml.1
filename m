Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbYGNAuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbYGNAuk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 20:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbYGNAuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 20:50:32 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:53223 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbYGNAub (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 20:50:31 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Justin Mattock <justinmattock@gmail.com>
Subject: Re: [Bug #10954] hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x011f000c
In-Reply-To: Your message of "Sun, 13 Jul 2008 20:00:46 +0200."
             <c6ZRbn0adb.A.si.HIleIB@albercik>
From: Valdis.Kletnieks@vt.edu
References: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
            <c6ZRbn0adb.A.si.HIleIB@albercik>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1215996628_5013P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 13 Jul 2008 20:50:28 -0400
Message-ID: <15207.1215996628@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1215996628_5013P
Content-Type: text/plain; charset=us-ascii

On Sun, 13 Jul 2008 20:00:46 +0200, "Rafael J. Wysocki" said:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10954
> Subject		: hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x011f000c
> Submitter	: Justin Mattock <justinmattock@gmail.com>
> Date		: 2008-06-21 2:05 (23 days old)
> References	: http://marc.info/?l=linux-kernel&m=121401399622190&w=4
> 		  http://marc.info/?t=121416231700010&r=1&w=4

Not sure if it's the same bug or not, this one's been there since before
2.6.25 but I haven't bothered chasing it down before. It's still in 26-rc9-mmotd.

Jul 13 05:53:47 turing-police kernel: [ 1459.168266] ALSA sound/pci/hda/hda_intel.c:588: hda_intel: No response from codec, disabling MSI: last cmd=0x012f1c00
Jul 13 05:53:48 turing-police kernel: [ 1460.169265] ALSA sound/pci/hda/hda_intel.c:601: hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x012f1c00

Dell Latitude D820, x86_64 kernel.  Audio device is:

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 01)

dmidecode says it's a "Sigmatel 9200".

I've been lazy chasing this one, because all that happens is that MSI gets
turned off, and it keeps going without it...

--==_Exmh_1215996628_5013P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIeqLUcC3lWbTT17ARAuOXAJ0ZPUePq1EKP+P4GZ1bstAc7teknwCgyOj3
N1jHqzaw6MS40J2VodoY6gQ=
=BeLd
-----END PGP SIGNATURE-----

--==_Exmh_1215996628_5013P--
