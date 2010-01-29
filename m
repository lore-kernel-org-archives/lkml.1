Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593Ab0A2Ke6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab0A2Ke6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 05:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744Ab0A2Ke6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 05:34:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752601Ab0A2Ke5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 05:34:57 -0500
Date: Fri, 29 Jan 2010 02:33:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: dedekind1@gmail.com,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Provide ways of crashing the kernel through debugfs
Message-Id: <20100129023327.021cb23d.akpm@linux-foundation.org>
In-Reply-To: <20100129071324.2521705c@marrow.netinsight.se>
References: <20100126105640.6bf9488c@marrow.netinsight.se>
	<2375c9f91001260208t31379702tb49cb57d12d5890b@mail.gmail.com>
	<20100126111853.10890fc6@marrow.netinsight.se>
	<2375c9f91001261853t1158a66aw86546a61e613338f@mail.gmail.com>
	<1264689482.1973.132.camel@localhost>
	<20100129071324.2521705c@marrow.netinsight.se>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jan 2010 07:13:24 +0100 Simon Kagstrom <simon.kagstrom@netinsight.net> wrote:

> On Thu, 28 Jan 2010 16:38:02 +0200
> Artem Bityutskiy <dedekind1@gmail.com> wrote:
> 
> > On Wed, 2010-01-27 at 10:53 +0800, Am__rico Wang wrote:
> > > > Well, it provides a few more ways of crashing the kernel. That's
> > > > basically the only additional feature you'll get.
> > > 
> > > Yeah, I can see that, but why do I need to care how I crash the kernel
> > > as long as I can crash it in a way.
> > 
> > But Simon did explain in his first e-mail why he cares. You or others
> > might care for similar reasons.
> 
> Another argument for the patch is that it's simple and well-contained,
> it doesn't touch any other code apart from the driver itself.
> 
> It is also easy to extend with other tests, e.g., provoking kernel
> hangs to test watchdogs and so on.
> 

Yes, it's the sort of thing which lots of people have written
throw-away ad-hoc versions of.  It probably makes sense to do it once,
do it right to save people from having to rererereinvent that wheel.

What do others think?
