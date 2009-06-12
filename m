Return-Path: <linux-kernel-owner+w=401wt.eu-S1763130AbZFLQss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763130AbZFLQss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbZFLQsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:48:38 -0400
Received: from avs1.arnes.si ([193.2.1.74]:55120 "EHLO avs1.arnes.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756338AbZFLQsi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:48:38 -0400
To: "Michael S. Zick" <lkml@morethan.org>, tomaz.mertelj@guest.arnes.si
From: tomaz.mertelj@guest.arnes.si
Cc: Harald Welte <HaraldWelte@viatech.com>, Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: =?UTF-8?Q?Re: [lm-sensors] [PATCH] hwmon: Add driver for VIA CPU core	temperature=
	?=
Date: Fri, 12 Jun 2009 18:48:39 +0200
Message-ID: <20090612_164839_072016.tomaz.mertelj@guest.arnes.si>
X-originating-IP: 84.20.248.126
MIME-Version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri June 12 2009, Michael S. Zick wrote:

> 
> The tool does not report read failures.
> **BUT** if you remember to "modprobe msr" or have it built in...
> Translation: Cockpit error.  ;)
> 
>

This is why rdmsr-tool reports file errors.

Here is the output:


DEBNAS:~#  for r in 0x1160 0x1161 0x1162 0x1163 0x1164 0x1165 
0x1166 0x1167 0x1
168 0x1169 0x116a 0x116b 0x116c 0x1152 0x1153 ; do  echo $r '->' 
`rdmsr  -x -0
$r` ;done;
0x1160 -> 00000000000005dc
0x1161 -> 00000000000003e8
0x1162 -> 0000000000000000
0x1163 -> 0000000000000000
0x1164 -> 000000000000005f
0x1165 -> 0000000000000064
0x1166 -> 000000000000007d
0x1167 -> 0000000000000000
0x1168 -> 0000000000000187
0x1169 -> 000000000000001d
0x116a -> 0000000000000003
0x116b -> 00000000000001a6
0x116c -> 00000000000003bf
0x1152 -> e78cb39ff7ffffff
0x1153 -> 0f180f18feffffff

via-cputemp-isa-0000
Adapter: ISA adapter
Core 0:      +28.0 C

Tomaz Mertelj

