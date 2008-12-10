Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbYLJAG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbYLJAG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 19:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbYLJAGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 19:06:49 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:4081 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbYLJAGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 19:06:49 -0500
Message-ID: <ac3eb2510812091606k5615135fn87d35aaa16834ea8@mail.gmail.com>
Date: Wed, 10 Dec 2008 01:06:47 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for December 9
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Greg KH" <greg@kroah.com>
In-Reply-To: <20081209153418.4628723d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081209185237.8bb715d7.sfr@canb.auug.org.au>
	 <20081209153418.4628723d.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 00:34, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 9 Dec 2008 18:52:37 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
>> I have created today's linux-next tree at
>> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
>
> udevd is sitting there chewing up 100% of a CPU all the time.
>
> The machine is x86_64, running FC6.  It still happens with
> CONFIG_SELINUX=n.
>
> config:                 http://userweb.kernel.org/~akpm/config-akpm2.txt
> dmesg:                  http://userweb.kernel.org/~akpm/dmesg-akpm2.txt
> strace of udevd:        http://userweb.kernel.org/~akpm/strace.out.txt
>
> excerpt:
>
> close(9)                                = 0
> open("/proc/21707/stat", O_RDONLY)      = 9
> read(9, "21707 (hald-addon-stor) S 21033 "..., 255) = 240
> close(9)                                = 0
> open("/proc/22340/stat", O_RDONLY)      = 9
> read(9, "22340 (smartd) S 1 22339 22339 0"..., 255) = 245
> close(9)                                = 0

Maybe an event loop, caused by something.

Are you still able to run:
  udevmonitor --kernel
and see if we get events, maybe in a loop, from the kernel?

Kay
