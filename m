Return-Path: <linux-kernel-owner+w=401wt.eu-S933569AbYBBTPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569AbYBBTPX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 14:15:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbYBBTPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 14:15:11 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33366 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754103AbYBBTPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 14:15:09 -0500
Date: Sat, 2 Feb 2008 11:15:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 1/2] Split list.h and move rcu-protected lists into
 rculist.h
Message-Id: <20080202111516.5cbd0880.akpm@linux-foundation.org>
In-Reply-To: <47A470F9.9060708@gmail.com>
References: <478FBEA0.9090203@gmail.com>
	<478FBEEA.6040000@gmail.com>
	<20080201155826.a2d308c1.akpm@linux-foundation.org>
	<47A470F9.9060708@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 02 Feb 2008 14:32:41 +0100 Franck Bui-Huu <vagabon.xyz@gmail.com> wrote:

> Andrew Morton wrote:
> > On Thu, 17 Jan 2008 21:47:38 +0100
> > Franck Bui-Huu <vagabon.xyz@gmail.com> wrote:
> > 
> >> This patch moves rcu-protected lists from list.h into a new header
> >> file rculist.h.
> > 
> > I'm getting way too many compilation errors from this, perhaps because of
> > new rcu-list usages which weren't present in the old tree (ie: current
> > Linus mainline) which you tested it against.
> > 
> 
> Not really suprising, sorry for the mess.
> 
> > The most practical way to prepare a patch like this is to either make it
> > back-compatible (for a while at least) or to prepare and carefully test it
> > against latest -mm.  That way you'll pick up everyone's new code.
> > 
> 
> I'll try to come up with something better: if rculist helpers are used from
> list.h then issue a warning otherwise every thing is fine since the helpers
> are imported from rculist.h.
> 
> Do you think it's better ?

Could.  I'd suggest that you redo the header-file split patch around the
2.6.25-rc1 timeframe, test it carefully then let's get it in then.

> In the meanwhile, could you drop the patches related to rculist from mm
> tree ?

I have done so.
