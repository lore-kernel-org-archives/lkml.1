Return-Path: <linux-kernel-owner+w=401wt.eu-S1752004AbZCIPmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbZCIPmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 11:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZCIPlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 11:41:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223AbZCIPlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 11:41:51 -0400
Date: Mon, 9 Mar 2009 08:40:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Stern <stern@rowland.harvard.edu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       =?ISO-8859-15?Q?Arve__Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [linux-pm] [RFC][PATCH][1/8] PM: Rework handling of interrupts
 during suspend-resume (rev. 5)
In-Reply-To: <Pine.LNX.4.44L0.0903091106010.3778-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.00.0903090837340.19207@localhost.localdomain>
References: <Pine.LNX.4.44L0.0903091106010.3778-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 9 Mar 2009, Alan Stern wrote:
> 
> I see.  The unstated key point is this:
> 
> 	Unsophisticated drivers [...]

Another key point is:

 - _un_sophisticated is the norm, and anybody who expects otherwise is 
   living in some odd la-la-land together with his or her pink unicorn and 
   endless supplies of quaaludes.

The thing is, we have about a metric sh*tload of drivers, and many of them 
are effectively written by people who don't really do kernel work, and are
basically unmaintained in the long run (ie they may be maintained while 
written, but two years down the line they have a couple of hundred users 
and nobody who really cares about it, because the original author long 
since moved on to fancier hardware).

			Linus
