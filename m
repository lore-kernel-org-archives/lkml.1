Return-Path: <linux-kernel-owner+w=401wt.eu-S1760077AbXH2Xe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077AbXH2Xe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 19:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754935AbXH2Xew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 19:34:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbXH2Xev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 19:34:51 -0400
Message-ID: <46D60255.2000606@redhat.com>
Date: Wed, 29 Aug 2007 19:33:41 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Oliver Neukum <oneukum@suse.de>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [stable] [patch 25/28] USB: cdc-acm: fix sysfs attribute	registration
 bug
References: <20070824154906.GA19239@kroah.com> <Pine.LNX.4.44L0.0708241349240.3862-100000@iolanthe.rowland.org> <20070824180423.GA5458@suse.de>
In-Reply-To: <20070824180423.GA5458@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2007 02:04 PM, Greg KH wrote:
>> I don't understand.  The history for stable/linux-2.6.22.y.git at
>> http://git.kernel.org shows that the commit for my patch, labelled
>>
>> 	6b30a4e1c357410a78d7bcb831743b0e99bab4ad,
>>
>> includes both hunks.  And patch-2.6.22.5.bz2 includes both as well.  
>> Something's fishy.
> 


*sigh*

The stable-queue tree does not match what got released for 2.6.22.5.

$ pwd
/home/me/git/stable-queue
$ grep cdc releases/2.6.22.5/*
$ 

$ bzcat patch-2.6.22.5.bz2 | grep cdc
index acdc3be..e2b9ca4 100644
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c

