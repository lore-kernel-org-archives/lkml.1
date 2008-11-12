Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbYKLP7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbYKLP7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 10:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752963AbYKLP7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 10:59:12 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:57563 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbYKLP7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 10:59:10 -0500
Date: Wed, 12 Nov 2008 21:28:07 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [PATCH 5/7] kprobes: Remove called_from argument
Message-ID: <20081112155807.GD5199@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <4919F1A9.5070601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4919F1A9.5070601@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 03:57:13PM -0500, Masami Hiramatsu wrote:
> Remove called_from argument from kprobes which had been used for preventing
> self-refering of kernel module. However, since we don't keep module's refcount
> after registering kprobe any more, there is no reason to check that.
> 
> This patch also simplifies registering/unregistering functions because we don't
> need to use __builtin_return_address(0) which was passed to called_from.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> ---
>  kernel/kprobes.c |   70 +++++++++++--------------------------------------------
>  1 file changed, 14 insertions(+), 56 deletions(-)

Subject to inclusion of the two-liner I sent out earlier today on top of this one
(needed anyway to get this to compile)..

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
