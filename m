Return-Path: <linux-kernel-owner+w=401wt.eu-S1752877AbZKDHld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbZKDHld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 02:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZKDHld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 02:41:33 -0500
Received: from [95.166.99.235] ([95.166.99.235]:56145 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbZKDHlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 02:41:32 -0500
Date: Wed, 4 Nov 2009 08:41:37 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robert Hancock <hancockrwd@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.32-rc4ish: task umount blocked for more than 120 seconds
	after USB drive removal
Message-ID: <20091104074137.GU8742@kernel.dk>
References: <4ADE9B79.9090906@gmail.com> <20091103151812.2acc5259.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091103151812.2acc5259.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03 2009, Andrew Morton wrote:
> On Tue, 20 Oct 2009 23:26:17 -0600
> Robert Hancock <hancockrwd@gmail.com> wrote:
> 
> > Running a post-2.6.32-rc4 git kernel, and just unmounted a USB drive 
> > after writing a bunch of data to it, then pulled the plug after I 
> > thought it had finished unmounting, but apparently it hadn't.. Ran into 
> > a hung task warning that repeats every 120 seconds, the umount command 
> > for the drive is stuck in D state.
> > 
> > The full SysRq-T output is shown at the bottom.. any ideas what it's 
> > waiting for?
> 
> At a guess I'd say the new per-bdi writeback stuff blew up.  Is this
> still happening in current mainline?

It happens in -rc6, it should be fixed in current -git. Robert, can you
try and confirm?

> It's remarkable how much harder these traces are to read post-wordwrapping.

Indeed, I always copy into a new buffer and un-wrap them :/

-- 
Jens Axboe

