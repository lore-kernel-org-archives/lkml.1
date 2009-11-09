Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbZKIQlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbZKIQlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 11:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbZKIQlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 11:41:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53127 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbZKIQlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 11:41:52 -0500
Message-ID: <4AF84640.7010705@zytor.com>
Date: Mon, 09 Nov 2009 08:41:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "Ma, Ling" <ling.ma@intel.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
 fast string.
References: <1257500482-16182-1-git-send-email-ling.ma@intel.com>	<4AF457E0.4040107@zytor.com> <4AF4784C.5090800@zytor.com>	<8FED46E8A9CA574792FC7AACAC38FE7714FCF772C9@PDSMSX501.ccr.corp.intel.com>	<4AF7C66C.6000009@zytor.com> <87ws2059s9.fsf@basil.nowhere.org>
In-Reply-To: <87ws2059s9.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2009 01:26 AM, Andi Kleen wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
>>
>> My personal opinion is that if we can show no significant slowdown on
>> P4, K8, P-M/Core 1, Core 2, and Nehalem then we can simply use this code
> 
> The issue is Core 2.
> 
> P4 uses a different path, and Core 1 doesn't use the 64bit code.
> 

Ling's numbers didn't seem to show a significant slowdown on Core 2 (it
was something like 0.95x baseline in the worst case, and most of the
cases were positive) so Core 2 doesn't seem to have a problem.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

