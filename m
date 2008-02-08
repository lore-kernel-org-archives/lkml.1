Return-Path: <linux-kernel-owner+w=401wt.eu-S1761813AbYBHUUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761813AbYBHUUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:20:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761140AbYBHUUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:20:16 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58958 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760366AbYBHUUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:20:14 -0500
Date: Fri, 8 Feb 2008 21:20:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jeff Mahoney <jeffm@suse.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at kernel/power/snapshot.c:464!
Message-ID: <20080208202022.GB13331@elf.ucw.cz>
References: <47ACA77E.2030001@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47ACA77E.2030001@suse.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Our old friend kernel BUG at kernel/power/snapshot.c:464! is back, this
> time from mainline. I can't reproduce with 2.6.24-final, but I can with
> a git snapshot from a few days ago. I'm doing a git bisect run now, but
> it's rather time consuming, so I thought I'd pass this on in the interim.
> 
> I can reproduce this just by doing "cat /dev/snapshot".
> 
> Working output looks like:
> swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
> swsusp: Marking nosave pages: 00000000f7ff0000 - 0000000100000000
> swsusp: Basic memory bitmaps created
> swsusp: Basic memory bitmaps freed

root@amd:~# cat /dev/snapshot
cat: /dev/snapshot: No data available
root@amd:~# 

...on less than two days old 2.6.25-rc0-git. Rafael, do you have any
ideas what may break?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
