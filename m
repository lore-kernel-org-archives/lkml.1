Return-Path: <linux-kernel-owner+w=401wt.eu-S1753774AbXDMRYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbXDMRYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 13:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbXDMRYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 13:24:21 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:58370 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbXDMRYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 13:24:20 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 2/5] sysfs: Remove first pass at shadow directory support
References: <m164898ncw.fsf@ebiederm.dsl.xmission.com>
	<m11wix8n74.fsf@ebiederm.dsl.xmission.com>
	<m1wt0p78k5.fsf_-_@ebiederm.dsl.xmission.com>
	<20070412225843.GA3713@kroah.com>
Date: Fri, 13 Apr 2007 11:23:24 -0600
In-Reply-To: <20070412225843.GA3713@kroah.com> (Greg KH's message of "Thu, 12
	Apr 2007 15:58:43 -0700")
Message-ID: <m1tzvknq7n.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> On Fri, Apr 06, 2007 at 10:48:42AM -0600, Eric W. Biederman wrote:
>> 
>> While shadow directories appear to be a good idea, the current scheme
>> of controlling their creation and destruction outside of sysfs appears
>> to be a locking and maintenance nightmare in the face of sysfs directories
>> dynamically coming and going.  Which can now occur for directories containing
>> network devices when CONFIG_SYSFS_DEPRECATED is not set.
>> 
>> This patch removes everything from the initial shadow directory support
>> that allowed the shadow directory creation to be controlled at a higher
>> level.  So except for a few bits of sysfs_rename_dir everything from
>> commit b592fcfe7f06c15ec11774b5be7ce0de3aa86e73 is now gone.
>
> Can you rebase patches 2-5 on the latest -mm?  Tejun redid the whole
> sysfs internals which pretty much means that this patch series doesn't
> apply anymore :(

Groan...

I expect so.  I'm in the middle of figuring out how to make kthread_stop
successfully terminate interruptible sleeps, so I can convert the
last hold outs using kernel_thread to kthread.

Which means it will be a day or two before I can look at this, unless
I get lucky and it happens to be a trivial rebase.

Eric
