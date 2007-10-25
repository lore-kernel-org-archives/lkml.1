Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbXJYQeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbXJYQeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbXJYQd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:33:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49839 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbXJYQd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:33:56 -0400
Message-ID: <4720C42B.7010303@zytor.com>
Date: Thu, 25 Oct 2007 09:28:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/3 -v4] x86_64 EFI runtime service support: EFI basic
 runtime service support
References: <1193295473.23935.202.camel@caritas-dev.intel.com> <alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> 
>> EFI runtime
>> services initialization are implemented in efi.c. Some x86_64
>> specifics are worth noting here. On x86_64, parameters passed to UEFI
>> firmware services need to follow the UEFI calling convention. For this
>> purpose, a set of functions named lin2win<x> (<x> is the number of
>> parameters) are implemented. EFI function calls are wrapped before
>> calling the firmware service.
> 
> Why needs this to be called lin2win? We do not call Windows, we call
> EFI services, so please use a naming convention which is related to
> the functionality of the code.
> 

Well, presumably EFI inherited the calling convention (as well as 
another bunch of stupidity) from that corner.

	-hpa
