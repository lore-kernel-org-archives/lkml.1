Return-Path: <linux-kernel-owner+w=401wt.eu-S1762079AbXIVJfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762079AbXIVJfY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 05:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbXIVJfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 05:35:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35661 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbXIVJfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 05:35:11 -0400
Date: Sat, 22 Sep 2007 10:35:08 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "David J. Wilder" <dwilder@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [Patch 1/2] Trace code and documentation (resend)
Message-ID: <20070922093508.GC27827@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"David J. Wilder" <dwilder@us.ibm.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <1190435014.27362.16.camel@lc4eb748232119.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190435014.27362.16.camel@lc4eb748232119.ibm.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 09:23:28PM -0700, David J. Wilder wrote:
> My last posting was mangled by my mailer.  I hope this one is better.
> Also corrected Randy's concerns.
> 
> Please see previous posting for more information:
> http://lkml.org/lkml/2007/9/19/4 (PATCH 0/2)
> 
> Note: this patch requires "[Patch 2/2] Relay reset consumed" is applied.
> 
> ---------<start of patch>------------
> Trace - Provides tracing primitives
> 
> Signed-off-by: Tom Zanussi <zanussi@us.ibm.com>
> Signed-off-by: Martin Hunt <hunt@redhat.com>
> Signed-off-by: David Wilder <dwilder@us.ibm.com>
> ---
>  Documentation/trace/src/Makefile     |    7 +
>  Documentation/trace/src/README       |   18 +
>  Documentation/trace/src/fork_trace.c |  119 +++++++
>  Documentation/trace/trace.txt        |  164 ++++++++++

NACK, don't put code into Documentation/.  Put it into kernel as it's
actually useful kernel code.  And add clone,exec and exit while you're at it.

