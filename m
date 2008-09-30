Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbYI3Nh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbYI3Nh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 09:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbYI3NhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 09:37:16 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:56281 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751669AbYI3NhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 09:37:13 -0400
Date: Tue, 30 Sep 2008 15:37:12 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Monty Montgomery <monty@xiph.org>
cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-scsi@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [regression] CD-DA delay needed after insertion
 (http://bugzilla.kernel.org/show_bug.cgi?id=10974)
In-Reply-To: <806dafc20809300548y4af5f10bs8a80caa24f176c79@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0809301535470.5818@vixen.sonytel.be>
References: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
 <1213648258.3420.12.camel@localhost.localdomain>
 <Pine.LNX.4.64.0806171530340.22840@vixen.sonytel.be>
 <1214605634.3394.91.camel@localhost.localdomain>
 <Pine.LNX.4.64.0806301120570.10868@vixen.sonytel.be>
 <1214841102.3381.5.camel@localhost.localdomain> <1214925487.3316.12.camel@localhost.localdomain>
 <Pine.LNX.4.64.0809171701330.21347@vixen.sonytel.be>
 <806dafc20809300117u2806e37bx986b54543862f358@mail.gmail.com>
 <Pine.LNX.4.64.0809301430370.5818@vixen.sonytel.be>
 <806dafc20809300548y4af5f10bs8a80caa24f176c79@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-228785917-1222781832=:5818"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-228785917-1222781832=:5818
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

	Hi Monty,

On Tue, 30 Sep 2008, Monty Montgomery wrote:
> > | 0x0ffd5730 in cdda_read_timed () from /usr/lib/libcdda_interface.so.0
> > | (gdb) bt
> > | #0  0x0ffd5730 in cdda_read_timed () from /usr/lib/libcdda_interface.so.0
> > | #1  0x0ffa7624 in i_read_c_block () from /usr/lib/libcdda_paranoia.so.0
> > | #2  0x0ffa9114 in paranoia_read_limited () from /usr/lib/libcdda_paranoia.so.0
> > | #3  0x10004da0 in ?? ()
> > | #4  0x0fd46704 in ?? () from /lib/libc.so.6
> > | #5  0x0fd468c0 in __libc_start_main () from /lib/libc.so.6
> > | #6  0x00000000 in ?? ()
> >
> > due to the `buffer' parameter being NULL.
> 
> Oh, good catch.  Platform/drive combination that hadn't been tripped
> here.  Fixing in SVN now.

OK, I'll take a look...

> (you're on bigendian or using an old bigendian SCSI drive?)

Yep. This is on PS3, which is ppc64 (albeit most userland is ppc32).

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-228785917-1222781832=:5818--
