Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbZD0OlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbZD0OlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 10:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755106AbZD0OlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 10:41:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56357 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055AbZD0OlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 10:41:05 -0400
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, monstr@monstr.eu, linux-api@vger.kernel.org,
       linux-arch@vger.kernel.org, liqin.chen@sunplusct.com,
       Sam Ravnborg <sam@ravnborg.org>,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: [RFC 00/17] asm-generic ABI files for microblaze
From: Arnd Bergmann <arnd@arndb.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?iso-8859-1?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60?=
 =?iso-8859-1?q?Y=2Ea=5E3zb?=)
 =?iso-8859-1?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5C?=
 =?iso-8859-1?q?wg=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
Date: Mon, 27 Apr 2009 16:40:43 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904271640.44445.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+3d2wNkrzFKYG2rMhUZCU17y1rb0F4FwcmVNg
 lbDa0PZpTlTi2ontkTkH6jU/cDgR4MbhczYqBaEJ9wN+SCv9RN
 cyoJh7ACM0U7sN8hDicDg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my attempt to do a generic system call ABI for
all new architectures, including a port for microblaze,
which has recently been merged into 2.6.30. The next
architecture that is about to get merged will be score,
so it would be good if they can move to the same ABI.

Please review the files and (in case of microblaze
and score maintainers) test them on your architecture.

The one part I'm not yet completely happy with is signal
handling, I had to massage the microblaze code quite a
bit to get the old-style siginfo out of it, which may
not yet work.

Sam also mentioned that it might be good to consistently
use the __u32 and similar types everywhere in asm-generic
exported headers, which I might be doing as a next step
(including the existing files).

Special thanks to Remis Baima, who has done some significant
work cleaning up my patches.

	Arnd <><
