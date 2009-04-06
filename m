Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbZDFVZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbZDFVZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbZDFVZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:25:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38784 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbZDFVZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:25:43 -0400
Date: Mon, 6 Apr 2009 17:24:17 -0400
From: Jason Baron <jbaron@redhat.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>, gnb@sgi.com
Subject: Re: [PATCH] Resurrect old pr_debug() semantics as pr_devel()
Message-ID: <20090406212417.GC3212@redhat.com>
References: <4a5c6b4cd1b77ebe6d60362bc982f4dc81cba85e.1238992196.git.michael@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a5c6b4cd1b77ebe6d60362bc982f4dc81cba85e.1238992196.git.michael@ellerman.id.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06, 2009 at 02:30:03PM +1000, Michael Ellerman wrote:
> pr_debug() used to produce zero code unless DEBUG was #defined. This is
> now no longer the case in practice[1].
> 
> There are places where it's useful to have debugging printks, but we
> don't want them to generate any code in production kernels.
> 
> So add a new macro, pr_devel(), for _devel_opment, to provide the old
> semantics, ie. if the programmer doesn't explicitly enable debugging,
> no code is produced.
> 
> [1]: You can turn CONFIG_DYNAMIC_DEBUG off, but it's enabled in at least
>      one distro kernel, so it's not really a solution.
> 

hmm...its designed to have low overhead when CONFIG_DYNAMIC_DEBUG
is on, but none of the debugging printks are enabled. Is there a
specific benchmark or test case that is unaccpetable?

thanks,

-Jason
