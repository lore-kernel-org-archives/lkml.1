Return-Path: <linux-kernel-owner+w=401wt.eu-S935708AbYD1P37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935708AbYD1P37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934510AbYD1P3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:29:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934381AbYD1P3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:29:49 -0400
Message-ID: <4815ECD0.80201@redhat.com>
Date: Mon, 28 Apr 2008 08:27:12 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, i2c@lm-sensors.org
Subject: Re: i2c or eeprom enumeration problem
References: <4815509A.9040802@redhat.com>	<20080428050515.fcc05689.akpm@linux-foundation.org>	<20080428141526.2f4e993f@hyperion.delvare>	<4815DC52.1050908@redhat.com> <20080428162123.7fd8eb04@hyperion.delvare>
In-Reply-To: <20080428162123.7fd8eb04@hyperion.delvare>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jean Delvare wrote:
> OK. Maybe it uses the same trick as the S4882... Can you get the
> information from Tyan?

I don't have a special link to Tyan but I can try.  What information do
you need?


> Please provide the output of i2cdetect for all the SMBus channels.

[Strange, the lm_sensors package in F9 doesn't have i2cdetect anymore.
Anything replacing it?]

I see two busses:

  Installed I2C busses:
    i2c-0       smbus           SMBus nForce2 adapter at a000
    i2c-1       smbus           SMBus nForce2 adapter at a040

Using -a to get all the info on those busses I see this:

Bus 0:

     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00: -- -- -- -- -- -- -- -- 08 -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- 18 -- -- -- -- -- -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
50: UU UU UU UU -- -- -- -- -- -- -- -- -- -- -- --
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


Bus 1:

     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00: -- -- -- -- -- -- -- -- 08 -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- 19 -- -- -- -- -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- -- 2d -- --
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
40: -- -- -- -- -- -- -- -- 48 49 -- -- -- -- -- --
50: -- UU -- -- -- -- -- -- -- -- -- -- -- -- -- --
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --



This motherboard uses the NVidia nForce n4250QE chipset.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIFezP2ijCOnn/RHQRAmd2AJ4gAQWzPhjBylM8g0Tzrw4L88xy0ACghI9q
Za0TJOrHDSlMzq8S2DShh4o=
=aCCS
-----END PGP SIGNATURE-----
