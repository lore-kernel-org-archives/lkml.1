Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbYGXLgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbYGXLgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 07:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbYGXLgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 07:36:05 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:35916 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752183AbYGXLgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 07:36:04 -0400
X-Sasl-enc: xyf4YsvsGoOYSmLLWVxPyPAWud5+n9pCQu6w96HTzfIq 1216899360
Message-ID: <4888691D.5090307@ladisch.de>
Date: Thu, 24 Jul 2008 13:35:57 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: lkml <linux-kernel@vger.kernel.org>, bob.picco@hp.com,
       venkatesh.pallipadi@intel.com, Vojtech Pavlik <vojtech@suse.cz>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [patch 2.6.26] /dev/hpet - fixes and cleanup
References: <200807221508.56672.david-b@pacbell.net> <4886E164.2070304@ladisch.de> <200807230912.49850.david-b@pacbell.net>
In-Reply-To: <200807230912.49850.david-b@pacbell.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> I didn't find any software using /dev/hpet, except for
> the example in Documentation/hpet.txt ... presumably I
> was looking in the wrong place. I'd surely have retched
> at anything mmapping hardware registers though.  ;)

http://subversion.jackaudio.org/jack/trunk/jack/config/os/gnu-linux/time.c

> > This seems to be the only part of the userspace interface that is
> > used in practice.  Because of the availability of POSIX timers, it might
> > make sense to deprecate the HPET ioctl interface.
>
> I'll leave that part up to someone else.  If POSIX timers
> are a sufficient userspace interface, great ... then that
> mmap son't really be needed either!

The idea is to be able to get a high-precision timer value without doing
a syscall.  (Whether the syscall overhead actually matters in a specific
application is another question.)


Regards,
Clemens
