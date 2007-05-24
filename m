Return-Path: <linux-kernel-owner+w=401wt.eu-S1751065AbXEXWOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751065AbXEXWOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbXEXWNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:13:49 -0400
Received: from ns1.suse.de ([195.135.220.2]:60458 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbXEXWNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:13:48 -0400
Date: Thu, 24 May 2007 15:04:17 -0700
From: Greg KH <gregkh@suse.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net,
       "art@usfltd.com" <art@usfltd.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Hans Verkuil <hverkuil@xs4all.nl>, Robert Fitzsimons <robfitz@273k.net>
Subject: Re: [3/3] 2.6.22-rc2: known regressions v2
Message-ID: <20070524220417.GA23561@suse.de>
References: <46558708.2040803@googlemail.com> <46559B5B.4060508@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46559B5B.4060508@googlemail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 04:04:11PM +0200, Michal Piotrowski wrote:
> Hi all,
> 
> Here is a list of some known regressions in 2.6.22-rc2.
> 
> Feel free to add new regressions/remove fixed etc.
> http://kernelnewbies.org/known_regressions
> 
> 
> 
> USB
> 
> Subject    : usb hotplug/udev cannot correctly register usb/scanners
> References : http://lkml.org/lkml/2007/5/15/205
> Submitter  : art@usfltd.com <art@usfltd.com>
> Status     : Unknown

I'm still working to track this down.  As scanners are in userspace, I
really suspect a bad udev rule here...

thanks,

greg k-h
