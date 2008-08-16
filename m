Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbYHPDuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbYHPDuD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 23:50:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYHPDtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 23:49:52 -0400
Received: from mga07.intel.com ([143.182.124.22]:2659 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751444AbYHPDtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 23:49:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,220,1217833200"; 
   d="scan'208";a="34300402"
Message-ID: <48A64E63.4000208@linux.intel.com>
Date: Sat, 16 Aug 2008 05:49:55 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Kay Sievers <kay.sievers@vrfy.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, gregkh <greg@kroah.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: Tree for August 14 (sysfs/acpi errors)
References: <20080814172945.250a27f2.sfr@canb.auug.org.au> <1218854219.3629.30.camel@lgn.site> <48A64235.2030108@linux.intel.com> <200808161347.41253.rusty@rustcorp.com.au>
In-Reply-To: <200808161347.41253.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Saturday 16 August 2008 12:57:57 Andi Kleen wrote:
>>>> Extract is:
>>>>
>>>> XXX adding modparam:'acpi.power_nocheck' 34 (ffffffff806a4cf0)
>>> ...
>>>
>>>> XXX adding modparam:'acpi.acpica_version' 45 (ffffffff806a4ea8)
>>> Two different "modules" use the same prefix, which does not work with
>>> the current logic, they need to live next to each other in the sequence
>>> of options.
>> Sequence of options being defined by link order?
> 
> Simplest fix is to shuffle Makefile.  But better is to create an acpi "module"
> so the namespacing just works, something like below.  Overriding MODULE_PREFIX
> only works for builtin code anyway.  (Which makes sense: moving a parameter
> from one module to another isn't a change we can cover up).

Can't say I like this. This is fragile. I can just this exploding the next time
again with some innocent change.

-Andi

