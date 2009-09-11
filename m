Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbZIKReM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbZIKReM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 13:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbZIKReL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 13:34:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbZIKReL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 13:34:11 -0400
Date: Fri, 11 Sep 2009 23:03:07 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Alan Cox <alan@linux.intel.com>, rusty@rustcorp.com.au,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for
	generic guest and host communication
Message-ID: <20090911173307.GB27046@amit-x200.redhat.com>
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <1252678386-17404-2-git-send-email-amit.shah@redhat.com> <20090911170010.34c80f2d@linux.intel.com> <20090911163806.GB25535@amit-x200.redhat.com> <4AAA8838.1080106@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AAA8838.1080106@codemonkey.ws>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Fri) Sep 11 2009 [12:26:16], Anthony Liguori wrote:
> Amit Shah wrote:
>> Right; there was some discussion about this. A few alternatives were
>> suggested like
>>
>> - udev scripts to create symlinks from ports to function, like:
>>
>>   /dev/vcon3 -> /dev/virtio-console/clipboard
>>
>> - Some fqdn-like hierarchy, like
>>
>>   /dev/virtio-console/com/redhat/clipboard
>>
>>   which again can be created by udev scripts
>>   
>
> And I dislike all of them.  What I'd rather have is these devices  
> exposed as tty's with a sys attribute that exposed the name of the 
> device.

A sysfs attribute can even be exposed with a char device.

I didn't want to venture more into tty after the hvc thing and the
unexpected bugs that crept up (memory corruption, which is now fixed in
linux-next). I'd rather just keep it limited to the subsystems I know.

		Amit
