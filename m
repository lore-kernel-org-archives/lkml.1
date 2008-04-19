Return-Path: <linux-kernel-owner+w=401wt.eu-S1758563AbYDSRs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563AbYDSRs3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 13:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755236AbYDSRsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 13:48:21 -0400
Received: from mail.queued.net ([207.210.101.209]:1813 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125AbYDSRsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 13:48:20 -0400
Date: Sat, 19 Apr 2008 13:50:47 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jfannin@gmail.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       jordan.crouse@amd.com
Subject: Re: 2.6.25-mm1
Message-ID: <20080419135047.5f77dfdb@ephemeral>
In-Reply-To: <20080419103833.8b609319.akpm@linux-foundation.org>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
	<20080419031024.GC3503@nineveh.local>
	<20080418202925.b18452c5.akpm@linux-foundation.org>
	<20080419092544.378664a8@ephemeral>
	<20080419103833.8b609319.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Apr 2008 10:38:33 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > On Sat, 19 Apr 2008 09:25:44 -0400 Andres Salomon <dilinger@queued.net> wrote:
> > On Fri, 18 Apr 2008 20:29:25 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Fri, 18 Apr 2008 23:10:24 -0400 Joseph Fannin <jfannin@gmail.com> wrote:
> > > 
> > > > On Fri, Apr 18, 2008 at 01:47:57AM -0700, Andrew Morton wrote:
[...]
> > > 
> > > which we probably just shouldn't do this at all unless we're running on the
> > > OLPC hardware.  But we need to do this to find out if we're running on the OLPC
> > > hardware!  Perhaps the warning should just be removed.
> > 
> > Hm.  We could either protect that code with an:
> > 
> > if (!is_geode())
> >   return;
> > 
> > Or I could add the OpenFirmware patches which would allow us to get
> > rid of this code, and instead check for the existence of OFW using
> > that.
> > 
> > The former is quick and easy; the latter is (imo) nicer, so long as
> > people don't have problems w/ the OFW code.  :)
> > 
> 
> Do both ;)
> 
> The quick-n-easy version sounds suitable for now.

Heh, I already had sent the nicer version.  If people have some fundamental
problem w/ it, I can send the quick-n-easy version.


-- 
Need a kernel or Debian developer?  Contact me, I'm looking for contracts.
