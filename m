Return-Path: <linux-kernel-owner+w=401wt.eu-S1763117AbXEPVXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763117AbXEPVXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 17:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760500AbXEPVXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 17:23:06 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:28693 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759984AbXEPVXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 17:23:03 -0400
Subject: Re: v2.6.21-rt2
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <20070516210104.GA17240@elte.hu>
References: <20070516180447.GA17922@elte.hu>
	 <1179348842.20519.20.camel@imap.mvista.com>
	 <20070516210104.GA17240@elte.hu>
Content-Type: text/plain
Date: Wed, 16 May 2007 14:20:48 -0700
Message-Id: <1179350448.20519.25.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-16 at 23:01 +0200, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > On Wed, 2007-05-16 at 20:04 +0200, Ingo Molnar wrote:
> > > i'm pleased to announce the v2.6.20-rt2 kernel, which can be downloaded 
> > > from the usual place:
> > 
> > 2.6.21-rt2 ?
> 
> oops, right! :-)
> 
> > >   - fixes for various problems by Steven Rostedt and Clark Williams
> > 
> > I think you missed the fix I submitted for one of Steve's changes.
> > 
> > http://lkml.org/lkml/2007/5/3/368
> 
> hm - trace_hardirqs_on() should never be called with irqs on - lockdep 
> could break for example. Could you try to fix the call site instead?

If that's the case why check if they're enabled inside
trace_hardirqs_on() ? If that check fails you still still get the
warning in my original release ..

Daniel

