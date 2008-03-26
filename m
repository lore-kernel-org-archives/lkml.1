Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbYCZIyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbYCZIyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 04:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYCZIyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 04:54:17 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:34488 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751880AbYCZIyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 04:54:15 -0400
Date: Wed, 26 Mar 2008 09:54:14 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Chris Snook <csnook@redhat.com>
cc: "J.C. Pizarro" <jcpiza@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: consistency: temperature versus metric bytes (was: Re: Why /proc/cpuinfo
 doesn't print L1,L2,L3 caches?)
In-Reply-To: <47E97566.5020003@redhat.com>
Message-ID: <Pine.LNX.4.64.0803260951100.23975@vixen.sonytel.be>
References: <998d0e4a0803251439u4bf09fb1ye568fc1970b0200f@mail.gmail.com>
 <47E97566.5020003@redhat.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-535557866-1206521582=:23975"
Content-ID: <Pine.LNX.4.64.0803260953050.23975@vixen.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-535557866-1206521582=:23975
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0803260953051.23975@vixen.sonytel.be>

On Tue, 25 Mar 2008, Chris Snook wrote:
> I think you want this:
> 
> /sys/devices/system/cpu/cpu0/cache
> 
> /proc/cpuinfo is intended to give a general summary of certain properties of
> the processor that tend to be particularly interesting, and present them all
> in one place.  It is not intended to expose everything the kernel knows about
> every processor on the system.

Oh my god! My caches run at different temperatures!! ;-)

| anakin$ cat /sys/devices/system/cpu/cpu0/cache/index*/size 
| 64K
| 64K
| 512K

Furthermore /proc/cpuinfo misses _more_ than 128 KiB:

| anakin$ cat /proc/cpuinfo 

    [...]

| cache size	: 512 KB
                  ^^^^^^

    [...]

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

Sony Network and Software Technology Center Europe
A division of Sony Service Centre (Europe) N.V.
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium
VAT BE 0413.825.160 · RPR Brussels
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584349381-535557866-1206521582=:23975--
