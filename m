Return-Path: <linux-kernel-owner+w=401wt.eu-S1759131AbYDWFFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759131AbYDWFFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 01:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbYDWFE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 01:04:59 -0400
Received: from ozlabs.org ([203.10.76.45]:55633 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbYDWFE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 01:04:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18446.50037.964682.539009@cargo.ozlabs.ibm.com>
Date: Wed, 23 Apr 2008 15:04:53 +1000
From: Paul Mackerras <paulus@samba.org>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] powerpc TLF_RESTORE_SIGMASK
In-Reply-To: <20080403210842.6C88C26F98D@magilla.localdomain>
References: <20080403210842.6C88C26F98D@magilla.localdomain>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath writes:

> This requires the earlier HAVE_SET_RESTORE_SIGMASK patch series.
> This does the same for powerpc that I posted the x86 change for.

...

> +static inline void set_restore_sigmask(void)
> +{
> +	struct thread_info *ti = current_thread_info();
> +	ti->local_flags |= TLF_RESTORE_SIGMASK;

This should be _TLF_RESTORE_SIGMASK (leading '_'), I think.

Paul.
