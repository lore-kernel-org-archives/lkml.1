Return-Path: <linux-kernel-owner+w=401wt.eu-S933085AbXCMUF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbXCMUF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 16:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933103AbXCMUF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 16:05:28 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:56955 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933085AbXCMUF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 16:05:27 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Jeff Garzik <jeff@garzik.org>
Subject: Re: Linux v2.6.21-rc3
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
	<m1zm6hq70n.fsf@ebiederm.dsl.xmission.com>
	<20070313194024.GA14847@suse.de>
Date: Tue, 13 Mar 2007 14:04:33 -0600
In-Reply-To: <20070313194024.GA14847@suse.de> (Greg KH's message of "Tue, 13
	Mar 2007 12:40:24 -0700")
Message-ID: <m1lki0rju6.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> I do not think this should be reverted, as the odds that some one will
> rename their network device to be "irq" or something else that is in the
> pci device's directory is pretty slim.  It also only shows up if
> CONFIG_SYSFS_DEPRECATED is disabled, not the common option.

Ah.  I missed that last little bit.

> But I am still working on it, I sent you and Kay a patch that, while it
> locks up at boot time, should be close to what we need to address this
> :)

Hmm.  I haven't seen that one.

>> - pci_save_state, pci_restore_state are broken and have been for a
>>   while if used on anything besides plain pci (pci-x, pci-e and msi)
>>   and are not used in pairs. (gregkh and Andrew have the patches to 
>>   correct this).
>
> I think these are already in Linus's tree right now, right?

Oops I missed that.

Eric
