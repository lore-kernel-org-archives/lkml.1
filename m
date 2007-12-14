Return-Path: <linux-kernel-owner+w=401wt.eu-S1757522AbXLNGHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbXLNGHc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 01:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbXLNGHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 01:07:24 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50625 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbXLNGHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 01:07:24 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@suse.de>
Cc: venkatesh.pallipadi@intel.com, ak@muc.de, rdreier@cisco.com,
       torvalds@linux-foundation.org, airlied@skynet.ie, davej@redhat.com,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 08/12] PAT 64b: coherent mmap and sysfs bin ioctl
References: <20071213235543.568682000@intel.com>
	<20071213235712.813201000@intel.com>
	<m18x3yq633.fsf@ebiederm.dsl.xmission.com>
	<20071214060203.GA10100@suse.de>
Date: Thu, 13 Dec 2007 23:04:21 -0700
In-Reply-To: <20071214060203.GA10100@suse.de> (Greg KH's message of "Thu, 13
	Dec 2007 22:02:03 -0800")
Message-ID: <m1k5nhq0be.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Thu, Dec 13, 2007 at 08:59:44PM -0700, Eric W. Biederman wrote:
>> venkatesh.pallipadi@intel.com writes:
>> 
>> > Forward port of coherent-mmap.patch and sysfs-bin-ioctl.patch to x86 tree.
>> >
>> > TBD: Do we need the ioctl interface to sysfs or get the type attribute
>> > through a different sysfs file. And then actually specify the attribute
>> > while doing pci_mmap_page_range ;-)
>> 
>> This ioctl is not connected up.  So regardless of the wisdom of ioctls on
>> sysfs adding the infrastructure and then not using it is broken.
>
> Ok, I guess the "use an ioctl on a binary file in sysfs for PCI devices"
> makes a bit more sense (hint, next time explain this in the changelog
> instead of just saying that it is being added), but I would like to see
> how this is all hooked up before passing final judgement on it.


The obvious thing to do would be to hook it up like:
drivers/pci/proc.c:proc_bus_pci_ioctl.

Eric
