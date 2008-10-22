Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbYJVR4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbYJVR4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbYJVR4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:56:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:58829 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824AbYJVR4g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:56:36 -0400
Date: Wed, 22 Oct 2008 10:56:49 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?UTF-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Re : [PATCH 2/2] fastboot: fix row order in bootgraph.pl
Message-ID: <20081022105649.7dbb288b@infradead.org>
In-Reply-To: <20081022143741.GA3263@elte.hu>
References: <48F49C0F.7050705@tuffmail.co.uk>
	<48F49C53.1070103@tuffmail.co.uk>
	<c62985530810140701s50f3a1an8da5383f8eefa29@mail.gmail.com>
	<20081022143741.GA3263@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 16:37:41 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
> 
> > 2008/10/14, Alan Jenkins <alan-jenkins@tuffmail.co.uk>:
> > > When bootgraph.pl parses a file, it gives one row for each
> > > initcall's pid.  But they are displayed in random (perl hash)
> > > order.  Let's sort the pids by the start time of their first
> > > initcall instead.
> > 
> > Thanks. That's a good idea!
> > 
> > I can't test it yet but I will give you a feedback as soon as I can.
> 
> i've applied the two fix patches from Alan to tip/tracing/urgent:
> 
>  06d1cd2: tracing/fastboot: fix row order in bootgraph.pl
>  2a813f8: tracing/fastboot: fix bootgraph.pl to run with "use strict"
> 
> Arjan, Steve, any objections?
> 
> 	Ingo
fine with me


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
