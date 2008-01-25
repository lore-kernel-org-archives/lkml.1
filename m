Return-Path: <linux-kernel-owner+w=401wt.eu-S1757281AbYAYRz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281AbYAYRz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 12:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbYAYRzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 12:55:50 -0500
Received: from mx1.suse.de ([195.135.220.2]:59301 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbYAYRzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 12:55:50 -0500
Date: Fri, 25 Jan 2008 09:54:21 -0800
From: Greg KH <gregkh@suse.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Mike Halcrow <mhalcrow@us.ibm.com>,
       Phillip Hellewell <phillip@hellewell.homeip.net>
Subject: Re: [PATCH 076/196] ecryptfs: remove version_str file from sysfs
Message-ID: <20080125175421.GD4242@suse.de>
References: <20080125071127.GA4860@kroah.com> <1201245134-4876-76-git-send-email-gregkh@suse.de> <47999CF2.9070805@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47999CF2.9070805@garzik.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 03:25:22AM -0500, Jeff Garzik wrote:
> Greg Kroah-Hartman wrote:
>> This file violates the one-value-per-file sysfs rule.
>> If you all want it added back, please do something like a per-feature
>> file to show what is present and what isn't.
>> Cc: Kay Sievers <kay.sievers@vrfy.org>
>> Cc: Mike Halcrow <mhalcrow@us.ibm.com>
>> Cc: Phillip Hellewell <phillip@hellewell.homeip.net>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>> ---
>>  fs/ecryptfs/main.c |   43 -------------------------------------------
>>  1 files changed, 0 insertions(+), 43 deletions(-)
>
> It's not really good policy to rip out ABIs found in release kernels like 
> this, even if the motivation is sound.

Normally I would agree, but this file is just so bad, it's not even
funny.  I could not find any userspace tools or documentation that used
it, and the ecryptfs developers never responded to any of my emails
concerning it.

The information is still present, just in a different file, so no
functionality is lost here.

> IMO "don't break ABIs" rule is far more important than a one-value-per-file 
> sysfs rule.

Just another example of why people need to document this kind of thing
in Documentation/ABI/ which prevents such atrocities from ever being
created in the first place...

thanks,

greg k-h
