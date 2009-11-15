Return-Path: <linux-kernel-owner+w=401wt.eu-S1752049AbZKOWyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbZKOWyX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 17:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbZKOWyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 17:54:22 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:48044 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbZKOWyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 17:54:21 -0500
Date: Sun, 15 Nov 2009 23:54:25 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Joe Perches <joe@perches.com>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Am??rico Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sysctl.c: Change a .proc_handler = proc_dointvec to
 &proc_dointvec,
In-Reply-To: <200911152053.35292.arnd@arndb.de>
Message-ID: <Pine.LNX.4.64.0911152351530.30372@ask.diku.dk>
References: <1258249925.16857.198.camel@Joe-Laptop.home>
 <1258313031.21668.73.camel@Joe-Laptop.home> <Pine.LNX.4.64.0911152139020.30372@ask.diku.dk>
 <200911152053.35292.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Nov 2009, Arnd Bergmann wrote:

> On Sunday 15 November 2009 20:40:25 Julia Lawall wrote:
> > It would be possible to count the number of occurrences in a given file, 
> > and then change the ones that have the less popular format, or a format 
> > that occurs less than some percentage of time.
> 
> How many of the 600 files use both formats?

This time I considered only cases where the function is defined in the 
same file, not where the function is presented only as a prototype.  I 
get:

502 files that use both options
83 files that only use & for function pointers
9374 files that never use & for function pointers

(Only files that use at least one of the options are considered.)

julia
