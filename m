Return-Path: <linux-kernel-owner+w=401wt.eu-S1762977AbZAPMPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762977AbZAPMPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 07:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756086AbZAPMPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 07:15:44 -0500
Received: from smtp.nokia.com ([192.100.122.230]:18502 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080AbZAPMPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 07:15:43 -0500
Date: Fri, 16 Jan 2009 14:15:24 +0200 (EET)
Message-Id: <20090116.141524.236287675.Hiroshi.DOYU@nokia.com>
To: roel.kluin@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 01/10] omap mailbox: cleanup omap2 register definition
 with macro
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
In-Reply-To: <25e057c00901160156w6058ade2j9c99ef727d8767ab@mail.gmail.com>
References: <20090116081919.17571.34378.stgit@oreo.research.nokia.com>
	<20090116082706.17571.31102.stgit@oreo.research.nokia.com>
	<25e057c00901160156w6058ade2j9c99ef727d8767ab@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2009 12:15:25.0733 (UTC) FILETIME=[1CD60550:01C977D4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "ext roel kluin" <roel.kluin@gmail.com>
Subject: Re: [PATCH 01/10] omap mailbox: cleanup omap2 register definition with macro
Date: Fri, 16 Jan 2009 10:56:01 +0100

[...]
> > +#define MAILBOX_SYSCONFIG              0x010
> > +#define MAILBOX_SYSSTATUS              0x014
> > +#define MAILBOX_MESSAGE(m)             (0x040 + 4 * (m))
> > +#define MAILBOX_FIFOSTATUS(m)          (0x080 + 4 * (m))
> > +#define MAILBOX_MSGSTATUS(m)           (0x0c0 + 4 * (m))
> > +#define MAILBOX_IRQSTATUS(u)           (0x100 + 8 * (u))
> > +#define MAILBOX_IRQENABLE(u)           (0x108 + 8 * (u))
>                                                                   ^^^^^^^
> shouldn't this be
> #define MAILBOX_IRQENABLE(u)           (0x104 + 8 * (u))

Right. I'll fix, thanks.
