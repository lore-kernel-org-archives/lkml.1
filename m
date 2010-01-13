Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960Ab0AMNg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab0AMNg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 08:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961Ab0AMNg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 08:36:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:50232 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab0AMNg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 08:36:56 -0500
Subject: Re: [PATCH 1/3] rbtree: Introduce rb_for_each_entry
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
In-Reply-To: <20100113133442.GB5036@nowhere>
References: <1263387673-15231-1-git-send-email-acme@infradead.org>
	 <1263388569.4244.215.camel@laptop>  <20100113133442.GB5036@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jan 2010 14:36:37 +0100
Message-ID: <1263389797.4244.223.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-13 at 14:34 +0100, Frederic Weisbecker wrote:
> On Wed, Jan 13, 2010 at 02:16:09PM +0100, Peter Zijlstra wrote:
> > On Wed, 2010-01-13 at 11:01 -0200, Arnaldo Carvalho de Melo wrote:
> > > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > 
> > > Similar to list_for_each_entry, helps reducing boilerplate in many
> > > places and makes rbtrees closer to list.h macros.
> > > 
> > > First conversion will be in the tools/perf.
> > 
> > I'm still not sure you really want to do this, it might give people the
> > impression its a sane thing to do ;-)
> 
> 
> At least it matches many patterns in perf :)

Doesn't make it right.

