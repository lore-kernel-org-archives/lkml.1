Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbZISHBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbZISHBu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 03:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbZISHBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 03:01:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750AbZISHBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 03:01:48 -0400
Date: Sat, 19 Sep 2009 12:31:11 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Alan Cox <alan@linux.intel.com>, rusty@rustcorp.com.au,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for
	generic guest and host communication
Message-ID: <20090919070111.GA5582@amit-x200.redhat.com>
References: <1252678386-17404-2-git-send-email-amit.shah@redhat.com> <20090911170010.34c80f2d@linux.intel.com> <20090911163806.GB25535@amit-x200.redhat.com> <4AAA8838.1080106@codemonkey.ws> <20090911173307.GB27046@amit-x200.redhat.com> <4AAA8A56.3040707@codemonkey.ws> <20090916112332.6bf981a5@linux.intel.com> <4AB164A0.8000402@codemonkey.ws> <20090918170048.53ba8cf6@linux.intel.com> <4AB3C988.2040303@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB3C988.2040303@codemonkey.ws>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Fri) Sep 18 2009 [12:55:20], Anthony Liguori wrote:
>> So you need a tiny kernel side driver to unpack it into a meaningful
>> fs, or just a user-user channel with a daemon each end and a protocol
>> over it - nothing kernel in that.
>>   
>
> I think there's some confusion over what this driver actually is.
>
> From my perspective, this is a paravirtual serial device and nothing  
> more.  All the discussion of things like guest copy/paste support is a  
> bit silly.  This is the wrong way to approach that sort of thing because  
> it's not something that belongs in the kernel at all.  Furthermore, the  
> current proposal doesn't handle anything like save/restore which is  
> needed for live migration.

You're mistaken. If you see the patches, I'm only providing a transport
in the kernel. No intelligence in the kernel as to what kind of data
actually flows through. The save/restore support has to come from
userspace, in this case qemu. And that support is very much present.

		Amit
-- 
http://log.amitshah.net/
