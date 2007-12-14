Return-Path: <linux-kernel-owner+w=401wt.eu-S1765724AbXLNECx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765724AbXLNECx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 23:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756308AbXLNECq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 23:02:46 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48457 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829AbXLNECp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 23:02:45 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: venkatesh.pallipadi@intel.com
Cc: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 08/12] PAT 64b: coherent mmap and sysfs bin ioctl
References: <20071213235543.568682000@intel.com>
	<20071213235712.813201000@intel.com>
Date: Thu, 13 Dec 2007 20:59:44 -0700
In-Reply-To: <20071213235712.813201000@intel.com> (venkatesh pallipadi's
	message of "Thu, 13 Dec 2007 15:55:51 -0800")
Message-ID: <m18x3yq633.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

venkatesh.pallipadi@intel.com writes:

> Forward port of coherent-mmap.patch and sysfs-bin-ioctl.patch to x86 tree.
>
> TBD: Do we need the ioctl interface to sysfs or get the type attribute
> through a different sysfs file. And then actually specify the attribute
> while doing pci_mmap_page_range ;-)

This ioctl is not connected up.  So regardless of the wisdom of ioctls on
sysfs adding the infrastructure and then not using it is broken.

> And when this interface is in place, X server has to use this interface for WC
> mapping.

Eric
