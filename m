Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab0APR74 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 12:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408Ab0APR7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 12:59:55 -0500
Received: from lo.gmane.org ([80.91.229.12]:54948 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932182Ab0APR7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 12:59:54 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Ubuntu 32-bit, 32-bit PAE, 64-bit Kernel Benchmarks
Date: Sat, 16 Jan 2010 12:59:16 -0500
Message-ID: <hisupj$hdn$1@ger.gmane.org>
References: <SNT125-W41CEF6892DBE0B1FD99B4AC3780@phx.gbl>,<4B511B12.6010208@zytor.com> <SNT125-W39A63687E4BE4F52FAA517C3680@phx.gbl> <4B514656.5080805@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: pool-72-92-176-205.albyny.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 pango-text SeaMonkey/1.1.16
In-Reply-To: <4B514656.5080805@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 01/15/2010 06:06 PM, Yuhong Bao wrote:
>>> The big difference isn't between HIGHMEM4G (no PAE) and HIGHMEM64G
>>> (PAE), it's between HIGHMEM and !HIGHMEM. That cutoff is ~892 MB for a
>>> stock 32-bit kernel.
>> Unfortunately most desktop/laptop systems nowadays ship with more than 1GB.Luckily, in the case of Atom netbooks that Linus mentioned, most Atom netbooks ship with only 1GB of RAM, partly due to MS's restrictions.However, disabling HIGHMEM will turn off NX which all Atom CPUs have, unless you turn CONFIG_PAE back on.
> 
> Since 32 bits means that any machine with 1 GB more means HIGHMEM, the
> number of non-embedded machines that should run 32-bit kernels today is
> functionally the null set.  Unfortunately Linux distros have not
> properly promoted 64-bit kernels for 32-bit distros; although pure 64
> bits is better, it would be a *helluva* lot better if people stuck on 32
> bits for compatibility reasons had a saner alternative.
> 
IIRC Fedora actually planned to offer that and dropped it. There seem to be 
display issues, I would assume the X stuff would have to match the kernel, 
although I'm basing that on reports. The only split I ever tried was text only.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

