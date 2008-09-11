Return-Path: <linux-kernel-owner+w=401wt.eu-S1752855AbYIKF2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbYIKF2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 01:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbYIKF2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 01:28:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:57427 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbYIKF2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 01:28:05 -0400
Date: Wed, 10 Sep 2008 21:52:55 -0700
From: Greg KH <gregkh@suse.de>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Oops/Warning report for the week of September 10th, 2008
Message-ID: <20080911045255.GD6863@suse.de>
References: <48C81D20.9040302@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C81D20.9040302@linux.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 12:16:48PM -0700, Arjan van de Ven wrote:
>
> Rank 2: sysfs_add_one (warning)
> 	Reported 215 times (3751 total reports)
> 	Duplicate sysfs registration; mostly in USB audio
> 	This warning was last seen in version 2.6.27-rc5, and first seen in 
> 2.6.24-rc6.
> 	More info: http://www.kerneloops.org/searchweek.php?search=sysfs_add_one

This one is going to be a bit tough to track over time as it is the low
level sysfs code complaining that a user of it is doing something wrong.
So you can get all sorts of different callers causing the same warning,
we just have to look at the backtrace to get a hint of who is causing
the problem.

Is there any way to break this one down further by caller so we can try
to narrow it down?  I thought you did that for other types of warnings
in the past (may_sleep(), etc.)

thanks,

greg k-h
