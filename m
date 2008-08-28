Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbYH1U0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbYH1U0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbYH1U0C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:26:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54918 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbYH1U0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:26:01 -0400
Message-ID: <48B7090C.3030506@zytor.com>
Date: Thu, 28 Aug 2008 13:22:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Austin Zhang <austin_zhang@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Cleanup and updates of x86 CPU definitions
References: <48B629D2.7040809@zytor.com> <48B70660.5020003@goop.org>
In-Reply-To: <48B70660.5020003@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> +#define X86_FEATURE_VMX		(4*32+ 5) /* Hardware virtualization */
>> +#define X86_FEATURE_SMX		(4*32+ 6) /* "Safer" mode */
>>   
> Is this supposed to appear as "Safer" in /proc/cpuinfo?  Or should this
> be ``Safer''?

It was a dumb-ass thinko on my part (already fixed in tip:x86/cpu).

	-hpa
