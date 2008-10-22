Return-Path: <linux-kernel-owner+w=401wt.eu-S1759970AbYJVRv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970AbYJVRv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760220AbYJVRs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:48:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41603 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760217AbYJVRs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:48:57 -0400
Date: Wed, 22 Oct 2008 13:48:53 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Re : [PATCH 2/2] fastboot: fix row order in bootgraph.pl
In-Reply-To: <20081022143741.GA3263@elte.hu>
Message-ID: <alpine.DEB.1.10.0810221348420.13500@gandalf.stny.rr.com>
References: <48F49C0F.7050705@tuffmail.co.uk> <48F49C53.1070103@tuffmail.co.uk> <c62985530810140701s50f3a1an8da5383f8eefa29@mail.gmail.com> <20081022143741.GA3263@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 22 Oct 2008, Ingo Molnar wrote:
> 
> * Fr?d?ric Weisbecker <fweisbec@gmail.com> wrote:
> 
> > 2008/10/14, Alan Jenkins <alan-jenkins@tuffmail.co.uk>:
> > > When bootgraph.pl parses a file, it gives one row for each initcall's
> > > pid.  But they are displayed in random (perl hash) order.  Let's
> > > sort the pids by the start time of their first initcall instead.
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

I have no objections.

-- Steve

