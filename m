Return-Path: <linux-kernel-owner+w=401wt.eu-S1757080AbYHSTcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080AbYHSTcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbYHSTcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:32:23 -0400
Received: from xenotime.net ([66.160.160.81]:37018 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753422AbYHSTcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:32:23 -0400
Date: Tue, 19 Aug 2008 12:32:14 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
cc: "Randy.Dunlap" <rdunlap@xenotime.net>, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, mpm@selenic.com,
       tglx@linutronix.de, rostedt@goodmis.org, cl@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, tzanussi@gmail.com
Subject: Re: [PATCH 1/5] Revert "kmemtrace: fix printk format warnings"
In-Reply-To: <20080819175440.GA5435@localhost>
Message-ID: <Pine.LNX.4.64.0808191229330.7877@shark.he.net>
References: <1219167807-5407-1-git-send-email-eduard.munteanu@linux360.ro>
 <Pine.LNX.4.64.0808191049260.7877@shark.he.net> <20080819175440.GA5435@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008, Eduard - Gabriel Munteanu wrote:

> On Tue, Aug 19, 2008 at 10:51:32AM -0700, Randy.Dunlap wrote:
> > On Tue, 19 Aug 2008, Eduard - Gabriel Munteanu wrote:
> > 
> > > This reverts commit 79cf3d5e207243eecb1c4331c569e17700fa08fa.
> > > 
> > > The reverted commit, while it fixed printk format warnings, it resulted in
> > > marker-probe format mismatches. Another approach should be used to fix
> > > these warnings.
> > 
> > Such as what?
> > 
> > Can marker probes be fixed instead?

Did you answer this?

> > After seeing & fixing lots of various warnings in the last few days,
> > I'm thinking that people don't look at/heed warnings nowadays.  Sad.
> > Maybe there are just so many that they are lost in the noise.
> 
> Hi,
> 
> Check the next patch in the series, it provides the alternate fix.

Yep, I saw that later.

> I favor this approach more because it involves fewer changes and we
> don't have to use things like "%zu" (which make data type size less
> apparent).

%zu is regular C language.  I.e., I don't get the data type not being
apparent issue...

Maybe kmemtrace should just make everything be long long... :(

-- 
~Randy
