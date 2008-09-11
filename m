Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbYIKN4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbYIKN4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 09:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbYIKN4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 09:56:36 -0400
Received: from mga10.intel.com ([192.55.52.92]:32441 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752801AbYIKN4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 09:56:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,379,1217833200"; 
   d="scan'208";a="379167835"
Message-ID: <48C92389.7070209@linux.intel.com>
Date: Thu, 11 Sep 2008 06:56:25 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Oops/Warning report for the week of September 10th, 2008
References: <48C81D20.9040302@linux.intel.com> <20080911045255.GD6863@suse.de>
In-Reply-To: <20080911045255.GD6863@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Sep 10, 2008 at 12:16:48PM -0700, Arjan van de Ven wrote:
>> Rank 2: sysfs_add_one (warning)
>> 	Reported 215 times (3751 total reports)
>> 	Duplicate sysfs registration; mostly in USB audio
>> 	This warning was last seen in version 2.6.27-rc5, and first seen in 
>> 2.6.24-rc6.
>> 	More info: http://www.kerneloops.org/searchweek.php?search=sysfs_add_one
> 
> 
> Is there any way to break this one down further by caller so we can try
> to narrow it down?  I thought you did that for other types of warnings
> in the past (may_sleep(), etc.)

ok I think I got this one sorted;
your entry is now replaced by

Rank 4: snd_card_register (warning)
	Reported 146 times (2594 total reports)
	This warning was last seen in version 2.6.25.14, and first seen in 2.6.24.
	More info: http://www.kerneloops.org/searchweek.php?search=snd_card_register

which is ALL usb audio... (so I might have to also skip snd_card_register in the backtrace, but I'll leave that between you and the alsa guys)

