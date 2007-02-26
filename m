Return-Path: <linux-kernel-owner+w=401wt.eu-S1030186AbXBZKhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030186AbXBZKhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 05:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030185AbXBZKhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 05:37:53 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:56045 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030183AbXBZKhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 05:37:52 -0500
Message-ID: <45E2B88B.1090706@gmail.com>
Date: Mon, 26 Feb 2007 11:38:03 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Uwe Bugla <uwe.bugla@gmx.de>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, bunk@stusta.de,
       linux-kernel@vger.kernel.org
Subject: Re: bug in kernel 2.6.21-rc1-git1: conventional floppy drive cannot
 be mounted without hanging up the whole system
References: <20070224175424.176030@gmx.net>
In-Reply-To: <20070224175424.176030@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Bugla napsal(a):
> Hi folks,

Hi.

> Once again and for the last time: I do not state that floppy.c is broken. I only state that it is immpossible to mount a floppy drive with kernel 2.6.21-rc1-git1. Kernel 2.6.20 is OK. But 2.6.21-rc1-git1 is definitely buggy!
> I did some work already:
> a. I copied the following modules from the intact and sane kernel 2.6.20 into the 2.6.21-rc1-git1 tree:
> cdrom.h, floppy.c, init.h, io.h, proc_misc.c, setup.c, timer.h, uaccess.h
> b. I adjusted some hunks of the patch for module main.c (part of patch-2.6.21-rc1) to make the kernel compile without errors.
> But the problem still persists, and I do not have any idea anymore where the offensive hunks in patch-2.6.21-rc1 could reside.
> 
> Questions:
> a. Can someone please confirm the described problem?

Yup (last -mm).

> b. Can someone please take action to find out where the buggy code resides?

I'll take a look. I've seen here and tried to debug it down some time ago
without any result. Sysrq is dead, probably some kind of locking issue. LOCKDEP
screams silence, code reading returned nothing. I thought, it's problem inside
my setup, I gave it up (even reporting). But it seems to be real problem now.

> c. Why is this untested material being pushed into main vanilla - what is going on at kernel.org please?

Hard to say, nobody is perfect, this should never happen, but unfortunately it does.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

Hnus <hnus@fi.muni.cz> is an alias for /dev/null

