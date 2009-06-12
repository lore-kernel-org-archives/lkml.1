Return-Path: <linux-kernel-owner+w=401wt.eu-S932430AbZFLRic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430AbZFLRic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 13:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbZFLRiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 13:38:22 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:43241 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761179AbZFLRiW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 13:38:22 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: tomaz.mertelj@guest.arnes.si
Subject: Re: [lm-sensors] [PATCH] hwmon: Add driver for VIA CPU =?iso-8859-1?q?core=09temperature?=
Date: Fri, 12 Jun 2009 12:38:19 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>, Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
References: <20090612_152510_043383.tomaz.mertelj@guest.arnes.si> <200906121031.05738.lkml@morethan.org> <200906121104.26174.lkml@morethan.org>
In-Reply-To: <200906121104.26174.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906121238.21568.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri June 12 2009, Michael S. Zick wrote:
>
> The tool does not report read failures.
> **BUT** if you remember to "modprobe msr" or have it built in...
> Translation: Cockpit error.  ;)
> 
> root@cb01:~# for r in 0x1160 0x1161 0x1162 0x1163 0x1164 0x1165 0x1166 0x1167 0x1168 0x1169 0x116a 0x116b 0x116c 0x1152 0x1153 ; do ./rdmsrll  $r ; done
> MSR register 0x1160 => 00:00:00:00:00:00:05:dc
> MSR register 0x1161 => 00:00:00:00:00:00:03:e8
> MSR register 0x1162 => 00:00:00:00:00:00:00:00
> MSR register 0x1163 => 00:00:00:00:00:00:00:00
> MSR register 0x1164 => 00:00:00:00:00:00:00:5f
> MSR register 0x1165 => 00:00:00:00:00:00:00:64
> MSR register 0x1166 => 00:00:00:00:00:00:00:7d
> MSR register 0x1167 => 00:00:00:00:00:00:00:00
> MSR register 0x1168 => 00:00:00:00:00:00:01:8d
> MSR register 0x1169 => 00:00:00:00:00:00:00:32
> MSR register 0x116a => 00:00:00:00:00:00:00:03
> MSR register 0x116b => 00:00:00:00:00:00:01:a6
> MSR register 0x116c => 00:00:00:00:00:00:03:34
> MSR register 0x1152 => e7:2c:b3:9f:fb:ff:ff:ff
> MSR register 0x1153 => 04:06:0c:09:fe:ff:ff:ff
> 
> Which is the same data as reported by msr-tools.
>

And the output of sensors with H.W. driver built-in:

root@cb01:~# sensors
acpitz-virtual-0
Adapter: Virtual device
temp1:       +48.8°C  (crit = +94.8°C)

via-cputemp-isa-0000
Adapter: ISA adapter
Core 0:      +50.0°C

Which looks reasonable to me, on this machine.

Mike 
> Mike 

