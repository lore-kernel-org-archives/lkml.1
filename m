Return-Path: <linux-kernel-owner+w=401wt.eu-S1752346AbXJUG3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbXJUG3Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 02:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbXJUG3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 02:29:19 -0400
Received: from mtoichi11.ns.itscom.net ([219.110.2.181]:59854 "EHLO
	mtoichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbXJUG3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 02:29:19 -0400
Date: Sun, 21 Oct 2007 15:28:47 +0900
From: Mattia Dongili <malattia@linux.it>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pavel@suse.cz
Subject: Re: mysqld prevents s2ram [Re: 2.6.23-mm1]
Message-ID: <20071021062847.GA3941@inferi.kami.home>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <20071021055816.GA4204@inferi.kami.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071021055816.GA4204@inferi.kami.home>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.23-mm1-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2007 at 02:58:17PM +0900, Mattia Dongili wrote:
> On Thu, Oct 11, 2007 at 09:31:26PM -0700, Andrew Morton wrote:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/
> 
> Ok, now that it boots let's go for more.
> 
> I cannot suspend if mysqld is running. mysql isn't atually doing
> anything useful anyway.
...
> As suggested in a different post I'll try reverting
> freezer-use-wait-queue-instead-of-busy-looping.patch and re-test

great, that was the guilty patch in fact.

-- 
mattia
:wq!
