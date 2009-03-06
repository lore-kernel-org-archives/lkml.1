Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbZCFTBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbZCFTBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 14:01:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbZCFTBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:01:41 -0500
Received: from usea-naimss3.unisys.com ([192.61.61.105]:3326 "EHLO
	usea-naimss3.unisys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbZCFTBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:01:41 -0500
Subject: Re: [tip:x86/apic] x86: MSI: check for BIOS assigned addresses
From: Daniel Yeisley <dan.yeisley@unisys.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, stable@kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20090306184514.GC15526@elte.hu>
References: <1236352309.31604.2.camel@localhost.localdomain>
	 <tip-affd49d36e2e2df4cbb3e07a57db901c23823b6a@git.kernel.org>
	 <20090306184514.GC15526@elte.hu>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 13:28:29 -0500
Message-Id: <1236364109.31604.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 (2.25.92-1.fc11) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Mar 2009 18:58:37.0915 (UTC) FILETIME=[8EBDCAB0:01C99E8D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 19:45 +0100, Ingo Molnar wrote:
> * Daniel Yeisley <dan.yeisley@unisys.com> wrote:
> 
> > Commit-ID:  affd49d36e2e2df4cbb3e07a57db901c23823b6a
> > Gitweb:     http://git.kernel.org/tip/affd49d36e2e2df4cbb3e07a57db901c23823b6a
> > Author:     "Daniel Yeisley" <dan.yeisley@unisys.com>
> > AuthorDate: Fri, 6 Mar 2009 10:11:49 -0500
> > Commit:     Ingo Molnar <mingo@elte.hu>
> > CommitDate: Fri, 6 Mar 2009 19:32:44 +0100
> > 
> > x86: MSI: check for BIOS assigned addresses
> > 
> > Impact: fix ACPI hotplug on certain systems
> 
> Note, this commit means that i moved the commit over from 
> tip:x86/urgent into tip:x86/apic - i.e. with a 2.6.30 merge 
> date. When exactly was this regression introduced? I think this 
> code never really accepted the MSI settings from the firmware, 
> so changing that behavior might affect a lot of systems.
> 
> So i'm uneasy about applying this fix this late in the .29 
> cycle, but marked it for -stable backport so it could hit 
> 2.6.29.1 if it stays problem-free.
> 
> 	Ingo

I initially noticed the problem on a 2.6.18 kernel.  ACPI hotplugging
didn't work unless I booted with pci=nomsi.  I don't have a problem with
waiting until 2.6.30 to make sure it is thoroughly tested.

Dan

