Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbYGDILq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbYGDILq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 04:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbYGDILb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 04:11:31 -0400
Received: from mail37.messagelabs.com ([216.82.244.163]:53994 "EHLO
	mail37.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbYGDILa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 04:11:30 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-10.tower-37.messagelabs.com!1215159088!4391636!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Fri, 4 Jul 2008 10:11:25 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Magnus Damm <magnus.damm@gmail.com>
CC: "Hans J. Koch" <hjk@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] uio: User IRQ Mode
Message-ID: <20080704081125.GA26703@digi.com>
References: <20080702105951.22648.2197.sendpatchset@rx1.opensource.se> <20080702125400.GC3199@local> <20080703071019.GC12214@digi.com> <20080703124505.GB3197@local> <aec7e5c30807032103p7626dcbdwe06c5fac461372c1@mail.gmail.com> <20080704060108.GA11794@digi.com> <aec7e5c30807040048yd8543d4n2edba43524279b6f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aec7e5c30807040048yd8543d4n2edba43524279b6f@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 04 Jul 2008 08:11:25.0785 (UTC) FILETIME=[8DC83C90:01C8DDAD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Magnus,

Magnus Damm wrote:
> > Maybe it's sensible to add the User IRQ Mode functions at least for now
> > into platform code.  Then at a later time if and when there are several
> > copies the discussion to move it to the generic part might be easier.
> 
> Do you mean your uio_pdrv driver?
No, I don't.  I meant arch/whatever/...

If you want to add it to uio_pdrv you either have to introduce a new
header file or you need to add it to uio_driver.h.  IMHO the first is
ugly and I'm sure Hans will object the latter.

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
