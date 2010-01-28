Return-Path: <linux-kernel-owner+w=401wt.eu-S1755078Ab0A1OjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab0A1OjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 09:39:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083Ab0A1OjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 09:39:04 -0500
Received: from smtp.nokia.com ([192.100.122.233]:32920 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab0A1OjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 09:39:01 -0500
Subject: Re: [PATCH] Provide ways of crashing the kernel through debugfs
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <2375c9f91001261853t1158a66aw86546a61e613338f@mail.gmail.com>
References: <20100126105640.6bf9488c@marrow.netinsight.se>
	 <2375c9f91001260208t31379702tb49cb57d12d5890b@mail.gmail.com>
	 <20100126111853.10890fc6@marrow.netinsight.se>
	 <2375c9f91001261853t1158a66aw86546a61e613338f@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jan 2010 16:38:02 +0200
Message-ID: <1264689482.1973.132.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 28 Jan 2010 14:38:35.0100 (UTC) FILETIME=[923B29C0:01CAA027]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-27 at 10:53 +0800, Américo Wang wrote:
> On Tue, Jan 26, 2010 at 6:18 PM, Simon Kagstrom
> <simon.kagstrom@netinsight.net> wrote:
> > Hi Americo!
> >
> > On Tue, 26 Jan 2010 18:08:28 +0800
> > Américo Wang <xiyou.wangcong@gmail.com> wrote:
> >
> >> On Tue, Jan 26, 2010 at 5:56 PM, Simon Kagstrom
> >> <simon.kagstrom@netinsight.net> wrote:
> >> > For development and testing it's sometimes useful to crash or injure the
> >> > kernel in various ways. This patch adds a debugfs interface to provoke
> >> > null-pointer dereferences, stack corruption, panics, bugons etc. For
> >> > example:
> >> >
> >> >  mount -t debugfs debugfs /mnt
> >> >  echo 1 > /mnt/provoke-crash/null_dereference
> >> >
> >> > Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
> >> > ---
> >> > Obviously this feature is for debugging and testing only, and of
> >> > interest to fairly few people. I've used it for testing the kmsg_dump
> >> > stuff (hence the CC:s above) and kdump, and have found it fairly useful.
> >> >
> >> > If it's not of interest, at least this mail will be in the archives if
> >> > someone else needs something like it :-)
> >>
> >> Hey, we already have /proc/sysrq-trigger, you need to state why
> >> it is better than using /proc/sysrq-trigger.
> >
> > Well, it provides a few more ways of crashing the kernel. That's
> > basically the only additional feature you'll get.
> >
> 
> Yeah, I can see that, but why do I need to care how I crash the kernel
> as long as I can crash it in a way.

But Simon did explain in his first e-mail why he cares. You or others
might care for similar reasons.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

