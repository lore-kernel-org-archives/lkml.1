Return-Path: <linux-kernel-owner+w=401wt.eu-S1751410AbZKIHgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbZKIHgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 02:36:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750800AbZKIHgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 02:36:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38197 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbZKIHgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 02:36:15 -0500
Message-ID: <4AF7C66C.6000009@zytor.com>
Date: Sun, 08 Nov 2009 23:36:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: "Ma, Ling" <ling.ma@intel.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
 fast string.
References: <1257500482-16182-1-git-send-email-ling.ma@intel.com> <4AF457E0.4040107@zytor.com> <4AF4784C.5090800@zytor.com> <8FED46E8A9CA574792FC7AACAC38FE7714FCF772C9@PDSMSX501.ccr.corp.intel.com>
In-Reply-To: <8FED46E8A9CA574792FC7AACAC38FE7714FCF772C9@PDSMSX501.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2009 11:24 PM, Ma, Ling wrote:
> Hi All
> 
> Today we run our benchmark on Core2 and Sandy Bridge:
> 

Hi Ling,

Thanks for doing that.  Do you also have access to any older CPUs?  I
suspect that the CPUs that Andi are worried about are older CPUs like
P4, K8 or Pentium M/Core 1.  (Andi: please do clarify if you have
additional information.)

My personal opinion is that if we can show no significant slowdown on
P4, K8, P-M/Core 1, Core 2, and Nehalem then we can simply use this code
unconditionally.  If one of them is radically worse than baseline, then
we have to do something conditional, which is a lot more complicated.

[Ingo, Thomas: do you agree?]

Thanks,

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

