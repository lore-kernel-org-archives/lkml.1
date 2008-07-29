Return-Path: <linux-kernel-owner+w=401wt.eu-S1759286AbYG2XDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286AbYG2XDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 19:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbYG2XDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 19:03:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbYG2XDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 19:03:02 -0400
Date: Tue, 29 Jul 2008 19:01:00 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: module-placed markers/tracepoints
Message-ID: <20080729230100.GA27711@redhat.com>
References: <48862A30.7050701@qumranet.com> <y0mabg991c3.fsf@ton.toronto.redhat.com> <488635A7.2030609@qumranet.com> <20080722221204.GA14661@Krystal> <488C49CC.8040800@qumranet.com> <20080728005405.GA7941@Krystal> <20080729161836.GA10751@redhat.com> <20080729170151.GA24851@Krystal> <20080729211543.GB17097@redhat.com> <20080729224115.GA5209@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729224115.GA5209@Krystal>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Tue, Jul 29, 2008 at 06:41:16PM -0400, Mathieu Desnoyers wrote:
> > Some locals are wondering -- is there code for (or need for new code
> > for) incrementing module reference counts while markers and/or
> > tracepoints resident in modules have active clients?
> 
> Probe module unloading is supposed to be done automatically assuming the
> following module unload behavior [...]

The question was more that if module-placed markers/tracepoints are
armed, is there any mechanism to prevent the modules' unloading.  For
kprobes, there is.

- FChE
