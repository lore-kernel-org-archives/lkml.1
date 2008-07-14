Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbYGNNt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbYGNNt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 09:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbYGNNtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 09:49:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454AbYGNNtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 09:49:51 -0400
Date: Mon, 14 Jul 2008 09:48:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm 2/2] kexec jump -v12: save/restore device state
Message-ID: <20080714134805.GD16673@redhat.com>
References: <1215401124.4660.5.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215401124.4660.5.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2008 at 11:25:24AM +0800, Huang Ying wrote:
> This patch implements devices state save/restore before after kexec.
> 
> 
> This patch together with features in kexec_jump patch can be used for
> following:
> 
> - A simple hibernation implementation without ACPI support. You can
>   kexec a hibernating kernel, save the memory image of original system
>   and shutdown the system. When resuming, you restore the memory image
>   of original system via ordinary kexec load then jump back.
> 
> - Kernel/system debug through making system snapshot. You can make
>   system snapshot, jump back, do some thing and make another system
>   snapshot.
> 
> - Cooperative multi-kernel/system. With kexec jump, you can switch
>   between several kernels/systems quickly without boot process except
>   the first time. This appears like swap a whole kernel/system out/in.
> 
> - A general method to call program in physical mode (paging turning
>   off). This can be used to invoke BIOS code under Linux.
> 

Huang,

You have cited various possible use cases of this patchset. Which is
the specific feature you are planning to use?

Thinking more about it, what's the compelling feature out of this list
which makes this patchset a strong candidate for inclusion?

Regarding hibernation, Rafael does not think this is the way to go 
for future.

Regarding ability to have two kernels in memory at the same time and
be able to jump between these two looks like a cool feature but who
is actually planning to use it?

So I am curious to know, which is the compelling feature you are planning
to use?

Thanks
Vivek
