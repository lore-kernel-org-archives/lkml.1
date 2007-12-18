Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbXLRJgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbXLRJgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 04:36:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbXLRJf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 04:35:56 -0500
Received: from colin.muc.de ([193.149.48.1]:1824 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbXLRJfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 04:35:55 -0500
Date: 18 Dec 2007 10:35:53 +0100
Date: Tue, 18 Dec 2007 10:35:53 +0100
From: Andi Kleen <ak@muc.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Paul Mackerras <paulus@samba.org>, Greg KH <gregkh@suse.de>,
       David Miller <davem@davemloft.net>, venkatesh.pallipadi@intel.com,
       rdreier@cisco.com, torvalds@linux-foundation.org, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: [RFC PATCH 08/12] PAT 64b: coherent mmap and sysfs bin ioctl
Message-ID: <20071218093553.GA20611@muc.de>
References: <20071213235543.568682000@intel.com> <20071213235712.813201000@intel.com> <20071214001932.GA10389@suse.de> <20071213.163505.14070110.davem@davemloft.net> <20071214063424.GB10100@suse.de> <18277.40798.828760.919571@cargo.ozlabs.ibm.com> <20071217124137.GA18648@muc.de> <m1ejdkd3qk.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ejdkd3qk.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well the other alternative looks like having a second file per par
> bar.  Say resource0_wc to support the write-combining mode, possibly

The intention was to support memory not in bars, but give a generic
IOMMU mapped memory interface for user space e.g. for the X server.
But that needs a way to return the bus address for the mmap mapping
and ioctl was the best I came up with for that.
Given it was never finished.

-Andi
