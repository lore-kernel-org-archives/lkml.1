Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963Ab0APEyF (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 23:54:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171Ab0APEyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 23:54:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50696 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab0APEyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 23:54:03 -0500
Message-ID: <4B514656.5080805@zytor.com>
Date: Fri, 15 Jan 2010 20:53:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Yuhong Bao <yuhongbao_386@hotmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: Ubuntu 32-bit, 32-bit PAE, 64-bit Kernel Benchmarks
References: <SNT125-W41CEF6892DBE0B1FD99B4AC3780@phx.gbl>,<4B511B12.6010208@zytor.com> <SNT125-W39A63687E4BE4F52FAA517C3680@phx.gbl>
In-Reply-To: <SNT125-W39A63687E4BE4F52FAA517C3680@phx.gbl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2010 06:06 PM, Yuhong Bao wrote:
> 
>> The big difference isn't between HIGHMEM4G (no PAE) and HIGHMEM64G
>> (PAE), it's between HIGHMEM and !HIGHMEM. That cutoff is ~892 MB for a
>> stock 32-bit kernel.
> Unfortunately most desktop/laptop systems nowadays ship with more than 1GB.Luckily, in the case of Atom netbooks that Linus mentioned, most Atom netbooks ship with only 1GB of RAM, partly due to MS's restrictions.However, disabling HIGHMEM will turn off NX which all Atom CPUs have, unless you turn CONFIG_PAE back on.

Since 32 bits means that any machine with 1 GB more means HIGHMEM, the
number of non-embedded machines that should run 32-bit kernels today is
functionally the null set.  Unfortunately Linux distros have not
properly promoted 64-bit kernels for 32-bit distros; although pure 64
bits is better, it would be a *helluva* lot better if people stuck on 32
bits for compatibility reasons had a saner alternative.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

