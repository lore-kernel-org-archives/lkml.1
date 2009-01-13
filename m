Return-Path: <linux-kernel-owner+w=401wt.eu-S1757639AbZAMUCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639AbZAMUCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 15:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbZAMUCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 15:02:31 -0500
Received: from mail.gmx.net ([213.165.64.20]:45961 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751995AbZAMUCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 15:02:30 -0500
Cc: mchehab@infradead.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, HWerner4@gmx.de,
       rjw@sisk.pl
Content-Type: text/plain; charset="iso-8859-1"
Date: Tue, 13 Jan 2009 21:02:14 +0100
From: handygewinnspiel@gmx.de
In-Reply-To: <20090113113700.776a94b5.akpm@linux-foundation.org>
Message-ID: <20090113200214.74570@gmx.net>
MIME-Version: 1.0
References: <20090112190420.51f75853@pedra.chehab.org>
	<20090112132130.6c932b85.akpm@linux-foundation.org>
	<20090112220624.4fbfee34@pedra.chehab.org>
	<20090112162337.318dd61d.akpm@linux-foundation.org>
	<20090113184755.87720@gmx.net>
	<20090113105947.9e774b69.akpm@linux-foundation.org>
	<20090113191757.74290@gmx.net> <20090113113700.776a94b5.akpm@linux-foundation.org>
Subject: Re: [linux-dvb] compiling on 2.6.28 broken?
To: Andrew Morton <akpm@linux-foundation.org>
X-Authenticated: #4875094
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1/hvHg6XZDhXExqOkyjlzhcClQk0UeoPaI98PxwJt
 soKwAHiRvSRWiZYV6GiM7bTOmG4N2hyrfy3w== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: J58HIWhITlI8Tz4GPWhr0eVOU2poZZns
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > Attached two strace logs, one for the failed version, one for the
> working version.
> > 
> 
> I'd have expected to see stat() returning -EOVERFLOW, but it isn't there.
> 
> googling around a bit seems to indcate that this might be a glibc issue:
> 
> http://sourceware.org/bugzilla/show_bug.cgi?id=1864
> http://bugs.gentoo.org/show_bug.cgi?id=146951
> 
> But the traces are all using stat64() and fstat64().  And why would it
> just start occurring now?

If that would be glibc related i would expect that other programs will fail with the very same behaviour - but i didnt notice that up to now. Nearly all programs are using glibc.

Since the error doesnt come up with 2.6.27.9 what changed afterwards which may touch that source?

GNU C Library 2004-07-01 release version 2.3.4, by Roland McGrath et al.
Copyright (C) 2004 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.
Compiled by GNU CC version 3.4.1.
Compiled on a Linux 2.6.8.1 system on 2005-06-03.
Available extensions:
        GNU libio by Per Bothner
        crypt add-on version 2.1 by Michael Glad and others
        Native POSIX Threads Library by Ulrich Drepper et al
        BIND-8.2.3-T5B
        NIS(YP)/NIS+ NSS modules 0.19 by Thorsten Kukuk
Thread-local storage support included.
For bug reporting instructions, please see:
<http://www.gnu.org/software/libc/bugs.html>.



-- 
Psssst! Schon vom neuen GMX MultiMessenger gehört? Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger
