Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbZIQGc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbZIQGc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 02:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbZIQGc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 02:32:27 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:6432 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699AbZIQGc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 02:32:26 -0400
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2009 02:32:26 EDT
X-IronPort-AV: E=Sophos;i="4.44,402,1249257600"; 
   d="scan'208";a="7119339"
User-Agent: Microsoft-Entourage/12.20.0.090605
Date: Thu, 17 Sep 2009 07:22:44 +0100
Subject: Re: [Xen-devel] [RFC][PATCH 03/10] xen/hybrid: Xen Hybrid Extension
 initialization
From: Keir Fraser <keir.fraser@eu.citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Sheng Yang <sheng@linux.intel.com>
CC: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Eddie Dong <eddie.dong@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jun Nakajima <jun.nakajima@intel.com>
Message-ID: <C6D79444.14F51%keir.fraser@eu.citrix.com>
Thread-Topic: [Xen-devel] [RFC][PATCH 03/10] xen/hybrid: Xen Hybrid Extension
 initialization
Thread-Index: Aco3C6mnFE8s5HAkQ0WALkQ4pbhd6QAU5qZB
In-Reply-To: <4AB1496B.9070705@goop.org>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 17 Sep 2009 06:22:47.0362 (UTC) FILETIME=[4641D220:01CA375F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/09/2009 21:24, "Jeremy Fitzhardinge" <jeremy@goop.org> wrote:

>> Guest would detect Hybrid capability using CPUID 0x40000002.edx, then call
>> HVMOP_enable_hybrid hypercall to enable hybrid support in hypervisor.
>>   
> 
> I think having an option to put PV guests into an HVM container is a
> good one, but as I mentioned in the other mail, I don't think this is
> the right approach.
> 
> It would be much better to make it so that an unmodified guest works in
> such a mode; even with no specific optimisations the guest would get
> benefit from faster kernel<->usermode switches.

By unmodified you mean ordinary PV guest? It's an interesting comparison --
PVing an HVM guest, versus HVMing (to some extent) a PV guest.

 -- Keir

> Then we can add specific optimisations to take advantage of, say,
> running in ring 0 (=fast syscalls) and having access to HAP hardware
> (=direct pagetable updates, no pinning).


