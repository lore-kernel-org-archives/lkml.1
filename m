Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268AbXJ3XGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbXJ3XGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 19:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbXJ3XGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 19:06:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbXJ3XGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 19:06:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <b1c6420f0710301459i147f0f00n1f7009139d3ac31a@mail.gmail.com>
References: <b1c6420f0710301459i147f0f00n1f7009139d3ac31a@mail.gmail.com> <20071029122759.2846.83510.stgit@warthog.procyon.org.uk> <b1c6420f0710300557j57cfc554m458adc7dbeeed610@mail.gmail.com> <15631.1193753689@redhat.com> <b1c6420f0710300810g1dbf8142j4c515a9baab4207a@mail.gmail.com> <27157.1193763218@redhat.com>
To: "Suzuki Takashi" <suzuki.takashi@gmail.com>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-am33-list] [PATCH 0/2] MN10300: Add the MN10300 architecture to Linux kernel [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Tue, 30 Oct 2007 23:06:04 +0000
Message-ID: <31286.1193785564@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Suzuki Takashi <suzuki.takashi@gmail.com> wrote:

> But is there any utility that depends on that uname says mn10300?

autoconf:-)

> I know existing developers should learn the arch name change.
> But how many developers?

I don't know.  MEI probably does.

> That's the point. They must always be told or consult the documentations.
> Don't you think an arch name should be natural?

Can you guarantee there won't be any non-AM33 variants of mn10300 that need
supporting?  An AM34, perhaps?

So basically, the toolchain name should change from am33 to mn10300 by your
argument.

> People need not to be told on other, at least major, archs.

There are plenty of other complications for other archs, such as 32-bit vs
64-bit, LE vs BE and other more subtle variants, so your argument isn't that
compelling.

> - growing new developers will have difficulties in understanding arch
> name difference,

You tell them, they then know.  It doesn't take long.  Standard practice, I
suspect, will involve giving them the toolchains and basic root filesystems.

The discrepancy has been around for years, and I suspect it's not going to
change now.  If MEI ask, I will change it.

David
