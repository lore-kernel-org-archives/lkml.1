Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbZAIGdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbZAIGdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 01:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbZAIGdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 01:33:23 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58809 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbZAIGdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 01:33:23 -0500
Date: Fri, 9 Jan 2009 15:32:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] NOOP cgroup subsystem
Message-Id: <20090109153219.dd8c153d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830901082226h6d47053cp801dafb67b6e2bc9@mail.gmail.com>
References: <20090109143226.b79d21b4.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830901082226h6d47053cp801dafb67b6e2bc9@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2009 22:26:46 -0800
Paul Menage <menage@google.com> wrote:

> On Thu, Jan 8, 2009 at 9:32 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> > Motivation: Simply classify Applications by cgroup
> >  When using cgroup for classifying applications, some kind of "control" or
> >  "account" subsys must be used. For flexible use of cgroup's nature of
> >  classifying applications, NOOP is useful. It can be used regardless of
> >  resource accounting unit or name spaces or some controls.
> >  IOW, NOOP cgroup allows users to tie PIDs with some nickname.
> 
> I agree that the idea is useful. But to me it seems to a bit
> artificial that you still have to mount some kind of subsystem purely
> to get the grouping, and that you can only have one such grouping.
> 
> I think I'd prefer the ability to mount a cgroups hierarchy without
> *any* subsystems (maybe with "-o none"?) which would give you a
> similar effect, but without you needing to know about a special no-op
> subsystem, and would allow you to have multiple "no-op" groupings.
> 

Oh, it seems better idea. Then, we need no configs and no additional subsys.
Thank you for a hint. I'll check how I can do it.

Thanks,
-Kame


