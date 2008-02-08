Return-Path: <linux-kernel-owner+w=401wt.eu-S1762868AbYBHU5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762868AbYBHU5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbYBHU5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:57:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46611 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295AbYBHU5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:57:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: kernel BUG at kernel/power/snapshot.c:464!
Date: Fri, 8 Feb 2008 21:55:30 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jeff Mahoney <jeffm@suse.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <47ACA77E.2030001@suse.com> <20080208202022.GB13331@elf.ucw.cz>
In-Reply-To: <20080208202022.GB13331@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802082155.30582.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 8 of February 2008, Pavel Machek wrote:
> Hi!
> 
> > Our old friend kernel BUG at kernel/power/snapshot.c:464! is back, this
> > time from mainline. I can't reproduce with 2.6.24-final, but I can with
> > a git snapshot from a few days ago. I'm doing a git bisect run now, but
> > it's rather time consuming, so I thought I'd pass this on in the interim.
> > 
> > I can reproduce this just by doing "cat /dev/snapshot".
> > 
> > Working output looks like:
> > swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
> > swsusp: Marking nosave pages: 00000000f7ff0000 - 0000000100000000
> > swsusp: Basic memory bitmaps created
> > swsusp: Basic memory bitmaps freed
> 
> root@amd:~# cat /dev/snapshot
> cat: /dev/snapshot: No data available
> root@amd:~# 
> 
> ...on less than two days old 2.6.25-rc0-git. Rafael, do you have any
> ideas what may break?

No idea and I can't reproduce it.

Plus the trace looks bogus, as there are no "swsusp: ..." messages in the
mainline any more.

Thanks,
Rafael
