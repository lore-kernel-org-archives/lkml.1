Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbZBCNwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbZBCNwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 08:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbZBCNwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 08:52:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:56860 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbZBCNwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 08:52:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [git pull -tip V2] fix headers_check warnings
Date: Tue, 3 Feb 2009 14:50:35 +0100
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       reiserfs-devel@vger.kernel.org
References: <1233598278.10133.4.camel@localhost.localdomain>
In-Reply-To: <1233598278.10133.4.camel@localhost.localdomain>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902031450.37016.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18iEjOEVbVbKoPmhfo6G/Guo5LF0VBL2q5CGMY
 yK7y7/xv00sKO4DTUh5uAjeXvfWY0ODGiTUWZbtrVDlLDsCGNY
 Bf99cJi60zB1iSFON4Mmg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 February 2009, Jaswinder Singh Rajput wrote:
> Jaswinder Singh Rajput (7):
>       headers_check fix: linux/coda_psdev.h
>       headers_check fix: linux/in6.h
>       headers_check fix: linux/nubus.h
>       headers_check fix: linux/socket.h
>       headers_check fix: linux/reinserfs_fs.h
>       headers_check fix: x86, prctl.h
>       headers_check fix: x86, setup.h

The new changes look good, thanks for your tireless effort to
cut down the warnings. However, my other previous comments still
apply.
In particular, the reiserfs_fs.h changes don't look helpful, how
about just not exporting that file?

	Arnd <><
