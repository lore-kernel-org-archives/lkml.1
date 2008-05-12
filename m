Return-Path: <linux-kernel-owner+w=401wt.eu-S1760926AbYELKN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760926AbYELKN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 06:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757642AbYELKNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 06:13:51 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:40575 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756095AbYELKNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 06:13:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ntld4uNiesPasW+BvqoRD/WACw2Da78/w8Ef8SwImuvC9nJVaMppKoCjjFNtW/9sPsIbpZznkxXdElGJcDMiWQzkfxTE/CJsKeF9MctROU3CNLDmE5NnX7dOefAvahpjx3070a6jEY6wKUMuFJtnKRjxmKjFHAZAfrchqwsey2g=
Message-ID: <f24d23310805120313o6385ff7av148aa109b2408ed7@mail.gmail.com>
Date: Mon, 12 May 2008 15:43:45 +0530
From: "debian developer" <debiandev@gmail.com>
To: "Roman Zippel" <zippel@linux-m68k.org>
Subject: 2.6.26-rc2 - ntp.c build failure
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roman,

The current rc2 does not build with allyesconfig. Seems there are lots
of errors...

Please find the error log below...

kernel/time/ntp.c: In function `ntp_leap_second':
kernel/time/ntp.c:150: error: `time_tai' undeclared (first use in this function)
kernel/time/ntp.c:150: error: (Each undeclared identifier is reported only once
kernel/time/ntp.c:150: error: for each function it appears in.)
kernel/time/ntp.c: In function `do_adjtimex':
kernel/time/ntp.c:328: error: `SHIFT_NSEC' undeclared (first use in
this function)
kernel/time/ntp.c:378: error: `mtemp' undeclared (first use in this function)
kernel/time/ntp.c:381: error: `freq_adj' undeclared (first use in this function)
kernel/time/ntp.c:382: warning: type defaults to `int' in declaration of `__x'
kernel/time/ntp.c:382: warning: type defaults to `int' in declaration of `__s'
kernel/time/ntp.c:386: error: `temp64' undeclared (first use in this function)
kernel/time/ntp.c:398: warning: type defaults to `int' in declaration of `_min1'
kernel/time/ntp.c:398: error: `MAXFREQ_NSEC' undeclared (first use in
this function)
kernel/time/ntp.c:398: warning: type defaults to `int' in declaration of `_min2'
kernel/time/ntp.c:399: warning: type defaults to `int' in declaration of `_max1'
kernel/time/ntp.c:399: warning: type defaults to `int' in declaration of `_max2'
kernel/time/ntp.c:400: error: implicit declaration of function
`div_long_long_rem_signed'
kernel/time/ntp.c:402: error: `rem' undeclared (first use in this function)
kernel/time/ntp.c:403: error: `SHIFT_UPDATE' undeclared (first use in
this function)
kernel/time/ntp.c:419: warning: type defaults to `int' in declaration of `__s'
kernel/time/ntp.c:279: warning: unused variable `sec'
kernel/time/ntp.c: At top level:
kernel/time/ntp.c:65: warning: 'ntp_update_offset' defined but not used
make[2]: *** [kernel/time/ntp.o] Error 1
make[1]: *** [kernel/time] Error 2
make: *** [kernel] Error 2
