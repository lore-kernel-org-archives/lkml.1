Return-Path: <linux-kernel-owner+w=401wt.eu-S1763786AbYGBLmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763786AbYGBLmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbYGBLm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:42:29 -0400
Received: from mail28.messagelabs.com ([216.82.249.131]:31040 "EHLO
	mail28.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbYGBLm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:42:28 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-15.tower-28.messagelabs.com!1214998948!19514396!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Wed, 2 Jul 2008 13:42:24 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Magnus Damm <magnus.damm@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hjk@linutronix.de" <hjk@linutronix.de>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] uio: User IRQ Mode
Message-ID: <20080702114224.GB6891@digi.com>
References: <20080702105951.22648.2197.sendpatchset@rx1.opensource.se> <20080702121153.4d464885@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080702121153.4d464885@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 02 Jul 2008 11:42:25.0123 (UTC) FILETIME=[B2826B30:01C8DC38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Wed, 02 Jul 2008 19:59:51 +0900
> Magnus Damm <magnus.damm@gmail.com> wrote:
> 
> > From: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> >
> > This patch adds a "User IRQ Mode" to UIO. In this mode the user space driver
> > is responsible for acknowledging and re-enabling the interrupt.
> > Shared interrupts are not supported by this mode.
> 
> This doesn't work even for some non shared interrupts.
> 
> If I take a level triggered interrupt then the IRQ handler code must
> clear the IRQ before the line can be unmasked.
Note that the irq is disabled instead of acked.  So this should not be a
problem.  The userspace part then is responsible to ack (first) and
unmask the irq.

This mis-understanding might be a hint to improve the commit log ...

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
