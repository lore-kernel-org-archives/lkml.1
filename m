Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbZKKPGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbZKKPGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 10:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757149AbZKKPGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 10:06:34 -0500
Received: from lucidpixels.com ([75.144.35.66]:38218 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757115AbZKKPGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 10:06:34 -0500
Date: Wed, 11 Nov 2009 10:06:39 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: Kernel: 2.6.31.5: CE: hpet increasing min_delta_ns: What do these
 messages mean?
Message-ID: <alpine.DEB.2.00.0911111002220.6957@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-104920207-1257951999=:6957"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-104920207-1257951999=:6957
Content-Type: TEXT/PLAIN; format=flowed; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

System: Intel DP55KG
CPU: Intel Core i870

I see these messages in my kernel log: (2.6.31.5)

[   48.886129] CE: hpet increasing min_delta_ns to 15000 nsec
[ 3258.107039] CE: hpet increasing min_delta_ns to 22500 nsec
[53705.451463] CE: hpet increasing min_delta_ns to 33750 nsec

I only see them when ACPI_FREQ and NO_HZ are enabled, to take advantage
of turbo boost.

It is not the result of throttling:

# cat /sys/devices/system/cpu/*/thermal_throttle/count
0
0
0
0
0
0
0
0

Temps are also good, 1 core @ 100% CPU:

Core 0:      +41.0=B0C  (high =3D +84.0=B0C, crit =3D +100.0=B0C)=20
Core 1:      +41.0=B0C  (high =3D +84.0=B0C, crit =3D +100.0=B0C)=20
Core 2:      +54.0=B0C  (high =3D +84.0=B0C, crit =3D +100.0=B0C)=20
Core 3:      +54.0=B0C  (high =3D +84.0=B0C, crit =3D +100.0=B0C)=20
Core 4:      +42.0=B0C  (high =3D +84.0=B0C, crit =3D +100.0=B0C)=20
Core 5:      +42.0=B0C  (high =3D +84.0=B0C, crit =3D +100.0=B0C)=20
Core 6:      +42.0=B0C  (high =3D +84.0=B0C, crit =3D +100.0=B0C)=20
Core 7:      +42.0=B0C  (high =3D +84.0=B0C, crit =3D +100.0=B0C)

I see various discussions on the meaning of these messages but no clear
answer.

Also in reference to loading ACPI_FREQ I mentioned before that when this
module is loaded and there is no CPU activity, there is a high pitch noise
from the CPU/VRM presumably, when ACPI_FREQ is not loaded, this does not
occur, is this expected?

Justin.
---1463747160-104920207-1257951999=:6957--
