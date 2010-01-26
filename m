Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197Ab0AZKS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab0AZKS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 05:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580Ab0AZKS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 05:18:57 -0500
Received: from ernst.netinsight.se ([194.16.221.21]:41787 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752576Ab0AZKS4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 05:18:56 -0500
Date: Tue, 26 Jan 2010 11:18:53 +0100
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Artem Bityutskiy <dedekind1@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Provide ways of crashing the kernel through debugfs
Message-ID: <20100126111853.10890fc6@marrow.netinsight.se>
In-Reply-To: <2375c9f91001260208t31379702tb49cb57d12d5890b@mail.gmail.com>
References: <20100126105640.6bf9488c@marrow.netinsight.se>
	<2375c9f91001260208t31379702tb49cb57d12d5890b@mail.gmail.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Americo!

On Tue, 26 Jan 2010 18:08:28 +0800
Américo Wang <xiyou.wangcong@gmail.com> wrote:

> On Tue, Jan 26, 2010 at 5:56 PM, Simon Kagstrom
> <simon.kagstrom@netinsight.net> wrote:
> > For development and testing it's sometimes useful to crash or injure the
> > kernel in various ways. This patch adds a debugfs interface to provoke
> > null-pointer dereferences, stack corruption, panics, bugons etc. For
> > example:
> >
> >  mount -t debugfs debugfs /mnt
> >  echo 1 > /mnt/provoke-crash/null_dereference
> >
> > Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
> > ---
> > Obviously this feature is for debugging and testing only, and of
> > interest to fairly few people. I've used it for testing the kmsg_dump
> > stuff (hence the CC:s above) and kdump, and have found it fairly useful.
> >
> > If it's not of interest, at least this mail will be in the archives if
> > someone else needs something like it :-)
> 
> Hey, we already have /proc/sysrq-trigger, you need to state why
> it is better than using /proc/sysrq-trigger.

Well, it provides a few more ways of crashing the kernel. That's
basically the only additional feature you'll get.

// Simon
