Return-Path: <linux-kernel-owner+w=401wt.eu-S1757383AbYCMVh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbYCMVh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 17:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbYCMVhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 17:37:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477AbYCMVhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 17:37:13 -0400
Date: Thu, 13 Mar 2008 14:35:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
Cc: paulus@samba.org, anton@samba.org, mingo@elte.hu, tglx@linutronix.de,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/4] powerpc copy_siginfo_from_user32
Message-Id: <20080313143510.9cfb7ab4.akpm@linux-foundation.org>
In-Reply-To: <20080313083107.8BDE926F992@magilla.localdomain>
References: <20080313083107.8BDE926F992@magilla.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Problems.

> Subject: [PATCH -mm 1/4] powerpc copy_siginfo_from_user32

This is advertised as a -mm patch but afacit it isn't against -mm.  And it
doesn't seem to be against mainline either?  At least, the fourth patch
fails to apply.

When trying to apply the fourth patch to -mm I hit a reject due to the new
BTS support in git-x86.  I stopped there because the patch might be invalid
because of this.

On Thu, 13 Mar 2008 01:31:07 -0700 (PDT)
Roland McGrath <roland@redhat.com> wrote:

> 
> Define the copy_siginfo_from_user32 entry point for powerpc, so
> that generic CONFIG_COMPAT code can call it.  We already had the
> code rolled into compat_sys_rt_sigqueueinfo, this just moves it
> out into the canonical function that other arch's define.
> 

Even though this appears to be a signal-related patch it is actually
ptrace-related, yes?

This patch is a prerequisite for "ptrace: compat_ptrace_request siginfo",
but this patch is independent from that patch (and from all others) and
hence this patch can be merged on its own into powerpc tree if we wish to go that
way, yes?  (Although probably it would be better not to do it that way, for
sanity's sake).


Anwyay, please help me out with the dependencies here, and take a look at
the x86 BTS stuff?

Thanks.

