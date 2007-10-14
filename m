Return-Path: <linux-kernel-owner+w=401wt.eu-S1760293AbXJNTa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760293AbXJNTa1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 15:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755103AbXJNTaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 15:30:20 -0400
Received: from lucidpixels.com ([75.144.35.66]:38658 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993AbXJNTaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 15:30:20 -0400
Date: Sun, 14 Oct 2007 15:30:18 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux-kernel@vger.kernel.org
cc: apiszcz@solarrain.com
Subject: 2.6.23.1 x86 hardware monitoring bug?
Message-ID: <Pine.LNX.4.64.0710141526590.3935@p34.internal.lan>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-372300202-1192390218=:3935"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-372300202-1192390218=:3935
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

As a regular user, I cannot see the sensors on the A-bit board, but I can=
=20
see the CPU temperature, how come I can see one but not the other?

Kernel: $ uname -a
Linux mybox 2.6.23.1 #4 SMP PREEMPT Sun Oct 14 15:20:53 EDT 2007 i686 GNU/L=
inux
Distribution: Debian Lenny

$ sensors
abituguru3-isa-00e0
Adapter: ISA adapter

coretemp-isa-0000
Adapter: ISA adapter
temp1:       +35=B0C  (high =3D   +85=B0C)

coretemp-isa-0001
Adapter: ISA adapter
temp1:       +36=B0C  (high =3D   +85=B0C)

As root:

# sensors
abituguru3-isa-00e0
Adapter: ISA adapter
CPU Core:               +1.35 V  (min  +0.00 V, max  +1.60 V)
DDR2:                   +2.02 V  (min  +1.60 V, max  +2.40 V)
DDR2 VTT:               +1.01 V  (min  +0.80 V, max  +1.20 V)
CPU VTT 1.2V:           +1.22 V  (min  +0.95 V, max  +1.45 V)
MCH & PCIE 1.5V:        +1.50 V  (min  +1.20 V, max  +1.80 V)
MCH 2.5V:               +2.58 V  (min  +2.00 V, max  +3.00 V)
ICH 1.05V:              +1.04 V  (min  +0.85 V, max  +1.25 V)
ATX +12V (24-Pin):     +12.18 V  (min  +9.60 V, max +14.40 V)
ATX +12V (4-pin):      +12.24 V  (min  +9.60 V, max +14.40 V)
ATX +5V:                +5.07 V  (min  +3.99 V, max  +6.00 V)
+3.3V:                  +3.40 V  (min  +2.64 V, max  +3.94 V)
5VSB:                   +5.10 V  (min  +3.99 V, max  +6.00 V)
CPU:                      +43=B0C  (high =3D   +75=B0C, crit =3D   +85=B0C)
System :                  +38=B0C  (high =3D   +55=B0C, crit =3D   +65=B0C)
PWM1:                     +43=B0C  (high =3D   +80=B0C, crit =3D   +90=B0C)
PWM2:                     +43=B0C  (high =3D   +80=B0C, crit =3D   +90=B0C)
PWM3:                     +46=B0C  (high =3D   +80=B0C, crit =3D   +90=B0C)
PWM4:                     +40=B0C  (high =3D   +80=B0C, crit =3D   +90=B0C)
CPU Fan:               1380 RPM  (min  300 RPM)
NB Fan:                   0 RPM  (min  300 RPM)
SYS Fan:                  0 RPM  (min  300 RPM)
AUX1 Fan:                 0 RPM  (min  300 RPM)
AUX2 Fan:                 0 RPM  (min  300 RPM)
AUX3 Fan:                 0 RPM  (min  300 RPM)
OTES1 Fan:                0 RPM  (min  300 RPM)

coretemp-isa-0000
Adapter: ISA adapter
Core 0:      +39=B0C  (high =3D   +85=B0C)

coretemp-isa-0001
Adapter: ISA adapter
Core 1:      +39=B0C  (high =3D   +85=B0C)

---1463747160-372300202-1192390218=:3935--
