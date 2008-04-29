Return-Path: <linux-kernel-owner+w=401wt.eu-S1760615AbYD2QYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760615AbYD2QYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 12:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbYD2QYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 12:24:04 -0400
Received: from www.tglx.de ([62.245.132.106]:41173 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbYD2QYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 12:24:03 -0400
Date: Tue, 29 Apr 2008 18:23:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] let setup_irq reenable a shared irq
In-Reply-To: <20080429130846.GA20461@digi.com>
Message-ID: <alpine.LFD.1.10.0804291822390.6003@apollo.tec.linutronix.de>
References: <1209381171-5520-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <alpine.LFD.1.10.0804281443090.3261@apollo.tec.linutronix.de> <20080428141116.GB9048@digi.com> <alpine.LFD.1.10.0804281640220.3261@apollo.tec.linutronix.de>
 <20080429130846.GA20461@digi.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-910444885-1209486214=:6003"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-910444885-1209486214=:6003
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 29 Apr 2008, Uwe Kleine-König wrote:
> > @@ -61,6 +61,7 @@ typedef	void (*irq_flow_handler_t)(unsig
> >  #define IRQ_WAKEUP		0x00100000	/* IRQ triggers system wakeup */
> >  #define IRQ_MOVE_PENDING	0x00200000	/* need to re-target IRQ destination */
> >  #define IRQ_NO_BALANCING	0x00400000	/* IRQ is excluded from balancing */
> > +#define IRQ_SPURIOUS_DISABLED	0x00400000	/* IRQ was disabled by the spurious trap */
>
> Is it intended that IRQ_NO_BALANCING == IRQ_SPURIOUS_DISABLED?

Doh, of course not :)

Thanks,
	tglx
--8323328-910444885-1209486214=:6003--
