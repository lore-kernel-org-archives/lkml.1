Return-Path: <linux-kernel-owner+w=401wt.eu-S1752501AbYJTV7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbYJTV7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 17:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbYJTV7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 17:59:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:54399 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbYJTV7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 17:59:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [RFC] Kernel version numbering scheme change
Date: Mon, 20 Oct 2008 23:58:41 +0200
User-Agent: KMail/1.9.9
Cc: Felipe Balbi <felipe.balbi@nokia.com>, Willy Tarreau <w@1wt.eu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Steven Noonan <steven@uplinklabs.net>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20081017034717.GA28188@kroah.com> <20081020205400.GB26744@gandalf.research.nokia.com> <20081020210648.GA30389@kroah.com>
In-Reply-To: <20081020210648.GA30389@kroah.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810202358.42050.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19oJdtYUiJhpvg6OSuuwbwmrJUD8g9lq6SqToj
 U1wkpoC2YECzdwmhS+QsW1YX8a+He5LFYGDGRSffhsZo1yzcRB
 TBP/TZFU888sfhI5wY8ug==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 October 2008, Greg KH wrote:
> Um, did you not get the memo 3 years ago saying we are changing our
> development model and there will not be a 2.7 development series?

Well, in theory we could resume the old numbering scheme again but
keep the current development model, in effect just inflating the
version numbers by one level:

2.6.28-rc1 -> 2.7.0
2.6.28-rc2 -> 2.7.1
2.6.28     -> 2.8.0 (perfect -- I've heard people informally call it
                     the two-eight release in the past instead of
                     two-six-twenty-eight)
2.6.28.1   -> 2.8.1
2.6.29-rc1 -> 2.9.0
2.6.29     -> 2.10.0 or 3.0.0 (depending on your taste)

This would be entirely consistent with how things have been since 1.0,
except that we have not had a 2.odd release in a long time.

	Arnd <><
