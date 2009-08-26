Return-Path: <linux-kernel-owner+w=401wt.eu-S933020AbZHZONW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020AbZHZONW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 10:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932964AbZHZONV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 10:13:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:41624 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932443AbZHZONU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 10:13:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="180401452"
Subject: Re: BUG: scheduling while atomic in acpi_ps_complete_op
From: ykzhao <yakui.zhao@intel.com>
To: Eric Paris <eparis@redhat.com>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Brown, Len" <len.brown@intel.com>,
       "vegard.nossum@gmail.com" <vegard.nossum@gmail.com>
In-Reply-To: <1251287895.2270.25.camel@dhcp231-106.rdu.redhat.com>
References: <1250873707.2168.38.camel@dhcp231-106.rdu.redhat.com>
	 <4A8EFFB2.4040100@suse.de>
	 <1250886352.2168.83.camel@dhcp231-106.rdu.redhat.com>
	 <4A8F1081.3020803@suse.de>
	 <1251124609.2359.25.camel@dhcp231-106.rdu.redhat.com>
	 <1251248426.3623.47.camel@localhost.localdomain>
	 <1251287895.2270.25.camel@dhcp231-106.rdu.redhat.com>
Content-Type: text/plain; charset=utf-8
Organization: Intel Open Source Technology Center
Date: Wed, 26 Aug 2009 22:13:04 +0800
Message-Id: <1251295984.3623.83.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-26 at 19:58 +0800, Eric Paris wrote:
> On Wed, 2009-08-26 at 09:00 +0800, ykzhao wrote:
> > On Mon, 2009-08-24 at 22:36 +0800, Eric Paris wrote:
> > > On Sat, 2009-08-22 at 01:24 +0400, Alexey Starikovskiy wrote:
> > > > Eric Paris пишет:
> 
> > > It does stop my slew of warnings.  Not sure it completely fixes my
> > > problems though....
> > Will you please add the boot option of initcall_debug and attach the
> > output of dmesg?
> > It will be helpful if you can attach the output of acpidump.
> > Thanks.
Hi
	Will you please confirm whether this issue happens on the 2.6.31-rc6
kernel?
	If there is no such issue, will you please revert the following commit
and see whether the issue still exists?
   >commit 74b5820808215f65b70b05a099d6d3c969b82689
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Wed Jul 29 15:54:25 2009 -0600

    ACPI: bind workqueues to CPU 0 to avoid SMI corruption

      In this commit it will schedule to other kernel thread and switch
to task 0 again.

Thanks.
    Yakui.    
> 
> Here is booting a kernel without the change.  I don't see acpidump
> packaged in fedora.  Do you have a pointer to the source or maybe a
> static binary?  I'll look myself later in the afternoon.
> 
> -Eric

