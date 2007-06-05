Return-Path: <linux-kernel-owner+w=401wt.eu-S1765191AbXFEOgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765191AbXFEOgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 10:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764569AbXFEOf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 10:35:29 -0400
Received: from lucidpixels.com ([75.144.35.66]:39152 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764750AbXFEOf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 10:35:28 -0400
Date: Tue, 5 Jun 2007 10:35:27 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux-kernel@vger.kernel.org
Subject: Kernel 2.6.22-rc4: Intel Quad Core Temperature Patch
Message-ID: <Pine.LNX.4.64.0706051027330.4372@p34.internal.lan>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-225880427-1181054127=:4372"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-225880427-1181054127=:4372
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

I am using stock cooling in a well ventilated case, I was wondering if=20
these temps are normal, e.g. I see this in dmesg:

[   60.505648] coretemp coretemp.0: Using undocumented features, absolute=
=20
temperature might be wrong!
[   60.505792] coretemp coretemp.1: Using undocumented features, absolute=
=20
temperature might be wrong!
[   60.505943] coretemp coretemp.2: Using undocumented features, absolute=
=20
temperature might be wrong!
[   60.506099] coretemp coretemp.3: Using undocumented features, absolute=
=20
temperature might be wrong!

When idle:

Jun  5 09:33:38 p34 cputemp[3580]: core1: 50=B0C
Jun  5 09:33:38 p34 cputemp[3580]: core2: 47=B0C
Jun  5 09:33:38 p34 cputemp[3580]: core3: 52=B0C
Jun  5 09:33:38 p34 cputemp[3580]: core4: 49=B0C

Under load:

Jun  5 10:30:01 p34 cputemp[6407]: core1: 79=B0C
Jun  5 10:30:01 p34 cputemp[6407]: core2: 77=B0C
Jun  5 10:30:01 p34 cputemp[6407]: core3: 79=B0C
Jun  5 10:30:01 p34 cputemp[6407]: core4: 77=B0C

Is this normal for Kentsfield Quad Core CPUs?

Justin.
---1463747160-225880427-1181054127=:4372--
