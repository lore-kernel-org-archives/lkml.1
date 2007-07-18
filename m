Return-Path: <linux-kernel-owner+w=401wt.eu-S936157AbXGRUDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936157AbXGRUDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 16:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934074AbXGRUDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 16:03:13 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60217 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933598AbXGRUDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 16:03:11 -0400
Message-ID: <469E71F9.5000005@garzik.org>
Date: Wed, 18 Jul 2007 16:03:05 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       chas@cmf.nrl.navy.mil, rolandd@cisco.com, dwmw2@infradead.org
Subject: Re: [git patches 1/2] warnings: attack valid cases spotted by	warnings
References: <20070717214239.GF28448@devserv.devel.redhat.com> <20070718024637.GC6146@suse.de>
In-Reply-To: <20070718024637.GC6146@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Jul 17, 2007 at 05:42:39PM -0400, Jeff Garzik wrote:
>> commit ae97fec3701a559929c3529e35417fab133a4d39
>> Author: Jeff Garzik <jeff@garzik.org>
>> Date:   Tue Jul 17 01:08:29 2007 -0400
>>
>>     drivers/usb/misc/auerswald: fix status check, remove redundant check
>>     
>>     1) We should only set 'actual_length' output variable if usb length is
>>     known to be good.
>>     
>>     2) No need to check actual_length for NULL.  The only caller always
>>     passes non-NULL value.
>>     
>>     Signed-off-by: Jeff Garzik <jeff@garzik.org>
> 
> I have no objection to this patch at all, however it does not remove the
> compiler warning :(

The description doesn't say it removes a warning, so it doesn't :)

You want to look at

	drivers/*: mark variables with uninitialized_var()

which was in posting "[git patches 2/2] warnings: use 
uninitialized_var()" and is now upstream commit 
a6343afb6e16b65b9f0b264f94f8207212e7e3ae

	Jeff


