Return-Path: <linux-kernel-owner+w=401wt.eu-S933465AbYAaNAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465AbYAaNAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 08:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764795AbYAaNAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 08:00:23 -0500
Received: from mail.gmx.net ([213.165.64.20]:58747 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757508AbYAaNAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 08:00:22 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/qWMd6k9zq+B3OjZ2T/xQqYzeH4dT1+dXWrl39ei
	WavHcQeXX9XU42
From: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Why do I have a /sys/devices/system/cpu/cpuidle under kernel 2.6.24 with a Pentium M processor ?
Date: Thu, 31 Jan 2008 14:00:14 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1542960.IlQAXW5lLW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801311400.17811.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1542960.IlQAXW5lLW
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I'm asking b/c this confuses the current sysstat up to version 8.0.4. An

$ ls -lR /sys/devices/system/cpu/

gives :

/sys/devices/system/cpu/:
total 0
drwxr-xr-x 4 root root 0 Jan 30 09:36 cpu0
drwxr-xr-x 2 root root 0 Jan 30 09:36 cpuidle

/sys/devices/system/cpu/cpu0:
total 0
drwxr-xr-x 3 root root 0 Jan 30 09:36 cpufreq
drwxr-xr-x 5 root root 0 Jan 30 09:36 cpuidle

/sys/devices/system/cpu/cpu0/cpufreq:
total 0
=2Dr--r--r-- 1 root root 4096 Jan 30 09:36 affected_cpus
=2Dr-------- 1 root root 4096 Jan 30 09:36 cpuinfo_cur_freq
=2Dr--r--r-- 1 root root 4096 Jan 30 09:36 cpuinfo_max_freq
=2Dr--r--r-- 1 root root 4096 Jan 30 09:36 cpuinfo_min_freq
drwxr-xr-x 2 root root    0 Jan 30 09:36 ondemand
=2Dr--r--r-- 1 root root 4096 Jan 30 09:36 scaling_available_frequencies
=2Dr--r--r-- 1 root root 4096 Jan 30 09:36 scaling_available_governors
=2Dr--r--r-- 1 root root 4096 Jan 30 09:36 scaling_cur_freq
=2Dr--r--r-- 1 root root 4096 Jan 30 09:36 scaling_driver
=2Drw-r--r-- 1 root root 4096 Jan 30 09:36 scaling_governor
=2Drw-r--r-- 1 root root 4096 Jan 30 09:36 scaling_max_freq
=2Drw-r--r-- 1 root root 4096 Jan 30 09:36 scaling_min_freq

/sys/devices/system/cpu/cpu0/cpufreq/ondemand:
total 0
=2Drw-r--r-- 1 root root    0 Jan 30 09:36 ignore_nice_load
=2Drw-r--r-- 1 root root 4096 Jan 30 09:36 powersave_bias
=2Drw-r--r-- 1 root root 4096 Jan 30 09:36 sampling_rate
=2Dr--r--r-- 1 root root 4096 Jan 30 09:36 sampling_rate_max
=2Dr--r--r-- 1 root root 4096 Jan 30 09:36 sampling_rate_min
=2Drw-r--r-- 1 root root 4096 Jan 30 09:36 up_threshold

/sys/devices/system/cpu/cpu0/cpuidle:
total 0
drwxr-xr-x 2 root root 0 Jan 30 09:36 state0
drwxr-xr-x 2 root root 0 Jan 30 09:36 state1
drwxr-xr-x 2 root root 0 Jan 30 09:36 state2

/sys/devices/system/cpu/cpu0/cpuidle/state0:
total 0
=2Dr--r--r-- 1 root root 4096 Jan 30 09:36 latency
=2Dr--r--r-- 1 root root 4096 Jan 30 09:36 name
=2Dr--r--r-- 1 root root 4096 Jan 30 09:36 power
=2Dr--r--r-- 1 root root 4096 Jan 30 09:36 time
=2Dr--r--r-- 1 root root 4096 Jan 30 09:36 usage

/sys/devices/system/cpu/cpu0/cpuidle/state1:
total 0
=2Dr--r--r-- 1 root root 4096 Jan 30 09:36 latency
=2Dr--r--r-- 1 root root 4096 Jan 30 09:36 name
=2Dr--r--r-- 1 root root 4096 Jan 30 09:36 power
=2Dr--r--r-- 1 root root 4096 Jan 30 09:36 time
=2Dr--r--r-- 1 root root 4096 Jan 30 09:36 usage

/sys/devices/system/cpu/cpu0/cpuidle/state2:
total 0
=2Dr--r--r-- 1 root root 4096 Jan 30 09:36 latency
=2Dr--r--r-- 1 root root 4096 Jan 30 09:36 name
=2Dr--r--r-- 1 root root 4096 Jan 30 09:36 power
=2Dr--r--r-- 1 root root 4096 Jan 30 09:36 time
=2Dr--r--r-- 1 root root 4096 Jan 30 09:36 usage

/sys/devices/system/cpu/cpuidle:
total 0
=2Dr--r--r-- 1 root root 4096 Jan 30 09:36 current_driver
=2Dr--r--r-- 1 root root 4096 Jan 30 09:36 current_governor_ro

=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart1542960.IlQAXW5lLW
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHocZhhyrlCH22naMRAqm0AKC6gF0XxXheqpQirf0+we8Zl59OgACdGfSx
46WPnGy+m9/1Dl6UPq3wNis=
=44zj
-----END PGP SIGNATURE-----

--nextPart1542960.IlQAXW5lLW--
