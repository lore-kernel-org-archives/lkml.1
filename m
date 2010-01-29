Return-Path: <linux-kernel-owner+w=401wt.eu-S1752172Ab0A2GNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab0A2GNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 01:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144Ab0A2GNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 01:13:33 -0500
Received: from ernst.netinsight.se ([194.16.221.21]:58643 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751025Ab0A2GNc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 01:13:32 -0500
Date: Fri, 29 Jan 2010 07:13:24 +0100
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: dedekind1@gmail.com
Cc: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Provide ways of crashing the kernel through debugfs
Message-ID: <20100129071324.2521705c@marrow.netinsight.se>
In-Reply-To: <1264689482.1973.132.camel@localhost>
References: <20100126105640.6bf9488c@marrow.netinsight.se>
	<2375c9f91001260208t31379702tb49cb57d12d5890b@mail.gmail.com>
	<20100126111853.10890fc6@marrow.netinsight.se>
	<2375c9f91001261853t1158a66aw86546a61e613338f@mail.gmail.com>
	<1264689482.1973.132.camel@localhost>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jan 2010 16:38:02 +0200
Artem Bityutskiy <dedekind1@gmail.com> wrote:

> On Wed, 2010-01-27 at 10:53 +0800, Américo Wang wrote:
> > > Well, it provides a few more ways of crashing the kernel. That's
> > > basically the only additional feature you'll get.
> > 
> > Yeah, I can see that, but why do I need to care how I crash the kernel
> > as long as I can crash it in a way.
> 
> But Simon did explain in his first e-mail why he cares. You or others
> might care for similar reasons.

Another argument for the patch is that it's simple and well-contained,
it doesn't touch any other code apart from the driver itself.

It is also easy to extend with other tests, e.g., provoking kernel
hangs to test watchdogs and so on.

// Simon
