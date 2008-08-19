Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbYHSTId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbYHSTId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbYHSTIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:08:21 -0400
Received: from po-out-1718.google.com ([72.14.252.153]:44109 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbYHSTIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:08:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=ulxaE07p7JU/OxtWz0IcyIIdvQziucimX29n/zrt86WwmO3M8Ad1j2FWBp7YqI5/Zt
         j3aEDXvSnZ6OCRB/H+Rk6vkIx1gO6NlukvzLFClKBfzzv5zwA67kZJT/skrGvI1xIsLL
         LJ4lvVEupRuyZmvRa17xOSlGF/SS7X1mBv9BE=
Date: Tue, 19 Aug 2008 22:05:06 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       rdunlap@xenotime.net, mpm@selenic.com, tglx@linutronix.de,
       rostedt@goodmis.org, mathieu.desnoyers@polymtl.ca, tzanussi@gmail.com
Subject: Re: [PATCH 3/5] SLUB: Replace __builtin_return_address(0) with
	_RET_IP_.
Message-ID: <20080819190506.GC5520@localhost>
References: <1219167807-5407-1-git-send-email-eduard.munteanu@linux360.ro> <1219167807-5407-2-git-send-email-eduard.munteanu@linux360.ro> <1219167807-5407-3-git-send-email-eduard.munteanu@linux360.ro> <48AB0D69.4090703@linux-foundation.org> <20080819182423.GA5520@localhost> <48AB1769.3040703@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AB1769.3040703@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 01:56:41PM -0500, Christoph Lameter wrote:

> Well maybe this patch will do it then:
> 
> Subject: slub: Use _RET_IP and use "unsigned long" for kernel text addresses
> 
> Use _RET_IP_ instead of buildint_return_address() and make slub use unsigned long
> instead of void * for addresses.
> 
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
> 
> ---
>  mm/slub.c |   46 +++++++++++++++++++++++-----------------------
>  1 file changed, 23 insertions(+), 23 deletions(-)

It seems Pekka just submitted something like this. Though I think using 0L
should be replaced with 0UL to be fully correct.

Pekka, should I test one of these variants and resubmit, or will you
merge it by yourself?

