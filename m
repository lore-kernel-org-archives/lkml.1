Return-Path: <linux-kernel-owner+w=401wt.eu-S935665AbXFFUbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935665AbXFFUbD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 16:31:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933796AbXFFUaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 16:30:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41957 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934835AbXFFUav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 16:30:51 -0400
Date: Wed, 6 Jun 2007 13:29:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com
Subject: Re: [RFC] PPS: Implementing LinuxPPS API with new syscalls
Message-Id: <20070606132934.18606a17.akpm@linux-foundation.org>
In-Reply-To: <20070605072501.GA15273@enneenne.com>
References: <20070605072501.GA15273@enneenne.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007 09:25:01 +0200 Rodolfo Giometti <giometti@enneenne.com> wrote:

> Hello,
> 
> after a little studing on new generic netlink interface and some
> letters with Andrew Morton I decided to drop using the netlink API at
> all and start using new specific syscalls.
> 
> Looking at current LinuxPPS API and at RFC2783 I think we need the
> following syscalls:
> 
>    asmlinkage long sys_time_pps_find(int cmd, int __user *source,
>                                           char __user *name, int namelen,
>                                           char __user *path, int pathlen);
>    asmlinkage long sys_time_pps_getparams(int source,
>                                           struct pps_params __user *params);
>    asmlinkage long sys_time_pps_setparams(int source,
>                                           const struct pps_params __user *params);
>    asmlinkage long sys_time_pps_getcap(int source, int __user *mode);
>    asmlinkage long sys_time_pps_fetch(int source, const int tsformat,
>                                           struct pps_info __user *info,
>                                           const struct timespec __user *timeout);

Could we please also see those structs which are being passed in and out of
the kernel?  It's a bit hard to understand the proposed interface without
that information.

They don't have to be 100% accurate - just an overview.

Hopefully each member of these structs has a little comment explaining what
it is, too...

Thanks.


