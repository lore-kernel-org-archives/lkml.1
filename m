Return-Path: <linux-kernel-owner+w=401wt.eu-S1759555AbXE2PCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555AbXE2PCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 11:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbXE2PCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 11:02:41 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750756AbXE2PCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 11:02:40 -0400
Date: Tue, 29 May 2007 08:01:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFC][PATCH][EXPERIMENTAL] Make kernel threads nonfreezable by
 default
In-Reply-To: <200705291415.31970.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.98.0705290759020.26602@woody.linux-foundation.org>
References: <200705270012.59177.rjw@sisk.pl> <200705282011.11526.rjw@sisk.pl>
 <20070529113114.GB23046@elf.ucw.cz> <200705291415.31970.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 May 2007, Rafael J. Wysocki wrote:
>
>  64 files changed, 230 insertions(+), 113 deletions(-)

Heh. Your previous patch removed more lines than it added, this one adds 
more lines than it removes. Snif..

I realize that it's all from that Documentation update:

 Documentation/power/freezing-of-tasks.txt |  160 ++++++++++++++++++++++++++++++
 Documentation/power/kernel_threads.txt    |   40 -------
 Documentation/power/swsusp.txt            |   18 ---

so it's all good. Anyway, I'll happily do this (along with the patch to 
not do freezer at all for STR) after 2.6.22 is out, but until then I'll 
obviously be ignoring the patches flying around..

		Linus
