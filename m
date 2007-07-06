Return-Path: <linux-kernel-owner+w=401wt.eu-S1763268AbXGFWOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763268AbXGFWOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 18:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758113AbXGFWOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 18:14:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757996AbXGFWOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 18:14:23 -0400
Message-ID: <468EBEB2.4070605@redhat.com>
Date: Fri, 06 Jul 2007 18:14:10 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] Scheduler profiling - Use immediate values
References: <20070703164046.645090494@polymtl.ca>	<20070703164516.377240547@polymtl.ca>	<20070703181151.GB5800@martell.zuzino.mipt.ru>	<20070703185748.GA4047@Krystal>	<20070705132120.8edbc1f3.akpm@linux-foundation.org> <p73vecx21um.fsf@bingen.suse.de>
In-Reply-To: <p73vecx21um.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2007 07:44 AM, Andi Kleen wrote:
> I think the optimization is a good idea, although i dislike it
> that it is complicated for the dynamic markers. If it was just
> static it would be much simpler.
> 

Another thing to consider is that there might be hundreds of these
probes/tracepoints active in an instrumented kernel. The overhead
adds up fast, so the gain may be worth all the pain.

