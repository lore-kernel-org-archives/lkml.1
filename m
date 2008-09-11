Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbYIKUxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbYIKUxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 16:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYIKUxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 16:53:37 -0400
Received: from ns.suse.de ([195.135.220.2]:41712 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbYIKUxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 16:53:37 -0400
Date: Thu, 11 Sep 2008 13:52:49 -0700
From: Greg KH <gregkh@suse.de>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Oops/Warning report for the week of September 10th, 2008
Message-ID: <20080911205249.GB21263@suse.de>
References: <48C81D20.9040302@linux.intel.com> <20080911045255.GD6863@suse.de> <48C92389.7070209@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C92389.7070209@linux.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2008 at 06:56:25AM -0700, Arjan van de Ven wrote:
> Greg KH wrote:
>> On Wed, Sep 10, 2008 at 12:16:48PM -0700, Arjan van de Ven wrote:
>>> Rank 2: sysfs_add_one (warning)
>>> 	Reported 215 times (3751 total reports)
>>> 	Duplicate sysfs registration; mostly in USB audio
>>> 	This warning was last seen in version 2.6.27-rc5, and first seen in 
>>> 2.6.24-rc6.
>>> 	More info: http://www.kerneloops.org/searchweek.php?search=sysfs_add_one
>> Is there any way to break this one down further by caller so we can try
>> to narrow it down?  I thought you did that for other types of warnings
>> in the past (may_sleep(), etc.)
>
> ok I think I got this one sorted;
> your entry is now replaced by
>
> Rank 4: snd_card_register (warning)
> 	Reported 146 times (2594 total reports)
> 	This warning was last seen in version 2.6.25.14, and first seen in 2.6.24.
> 	More info: 
> http://www.kerneloops.org/searchweek.php?search=snd_card_register
>
> which is ALL usb audio... (so I might have to also skip snd_card_register 
> in the backtrace, but I'll leave that between you and the alsa guys)

Yes, that's much better thanks.  I think that has now been fixed by
the ALSA people, as seen by no reports 2.6.26 and onward.

thanks,

greg k-h
