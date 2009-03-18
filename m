Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbZCRI4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbZCRI4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 04:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbZCRIzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 04:55:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:43111 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbZCRIzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 04:55:53 -0400
Subject: Re: [RFC][PATCH 09/11] perf_counter: revamp syscall input ABI
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
In-Reply-To: <18880.31021.850273.736650@drongo.ozlabs.ibm.com>
References: <20090317215606.037073805@chello.nl>
	 <20090317220421.336322251@chello.nl>
	 <18880.31021.850273.736650@drongo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 09:55:47 +0100
Message-Id: <1237366547.5069.79.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-18 at 15:31 +1100, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > The hardware/software classification in hw_event->type became a little strained
> > due to the addition of tracepoint tracing.
> > 
> > Instead split up the field and provide a type field to explicitly specify the
> > counter type, while using the event_id field to specify which event to use.
> 
> It would be nice if you didn't reuse the name 'type' but instead
> called the field something different ('class', perhaps?) to force a
> compile error on code that needs to be updated.  For example, you
> missed a spot in arch/powerpc/kernel/perf_counter.c and you need to
> add on the patch below.  (Thanks for updating powerpc BTW.)

Yeah, thought of that after I did the patch... :-)

Thanks.

