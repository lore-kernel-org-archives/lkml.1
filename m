Return-Path: <linux-kernel-owner+w=401wt.eu-S1759620AbXJDTyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620AbXJDTyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 15:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755605AbXJDTyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 15:54:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37780 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754349AbXJDTyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 15:54:10 -0400
Date: Thu, 4 Oct 2007 12:53:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mgross@linux.intel.com
Cc: arjan@infradead.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       mark.gross@intel.com
Subject: Re: [PATCH] PM_QOS 1 of 2
Message-Id: <20071004125356.69e01dfe.akpm@linux-foundation.org>
In-Reply-To: <20071001234528.GA5238@linux.intel.com>
References: <20071001234528.GA5238@linux.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007 16:45:28 -0700
Mark Gross <mgross@linux.intel.com> wrote:

> The following is the cleaned up patch implementing the power management
> quality of service infrastructure discussed at the pm summit last June.
> 
> It is a genralization of the latency code put into the kernel last year
> by Arjan.
> 
> I would like to get this code included in the MM tree and to get some
> milage on it.
> 
> One thing to note about this implementation is that it exposes an
> interface to user space for registering pm_qos constraints in addition
> to the kernel exports.  Its a file based interface where a module can
> register a constraint and the constraint is valid only as long as the
> device node is held open.  Upon closing of the device node that
> constraint is cleaned up.
> 
> The patch set is in two postings.  
> 1) the base parameter code (this email)
> 2) replacing of latency.c/latenc.h with pm_qos_params.c/pm_qos_params.h

I wouldn't really view this as an adequate changelog.

- The Subject:s are pretty pathetic (please see my suggesed replacements)

- There is no description of the proposed new kernel<->userspace
  interfaces.

  As you are proposing new and permanent enhancements to the Linux API,
  this is something which should be spelled out in some detail.  Because we
  can change the implementation, but we can not ever change your interface.

  It would be nice to get that interface described in Documentation/
  somewhere, but it is *critical* that the design be fully revealed right
  now, during review.


Anyway, I am not a suitable person to review this submission.

I'll put the patches in -mm for a bit of eyeball-and-test (not that anyone
will know how to test it, due to the secret interfaces) but I do not want
to move this code into mainline until someone who is familiar with the PM
code has performed a detailed review of both the implementation and the
design (whatever that is!).

Please send new, complete descriptions of these patches.  I don't think
they can be effectively reviewed without that information.  Except perhaps
by someone who was at the PM summit, but that's cheating.


Thanks.
