Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbYGNQt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbYGNQt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbYGNQtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:49:50 -0400
Received: from ns1.suse.de ([195.135.220.2]:52320 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352AbYGNQtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:49:49 -0400
Date: Mon, 14 Jul 2008 18:49:48 +0200
From: Olaf Dabrunz <od@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Olaf Dabrunz <od@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Stefan Assmann <sassmann@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Ihno Krumreich <ihno@suse.de>, Sven Dietrich <sdietrich@suse.de>,
       Daniel Gollub <dgollub@suse.de>, Felix Foerster <ffoerster@suse.de>
Subject: Re: [PATCH 0/3] Boot IRQ quirks for Broadcom and AMD/ATI
Message-ID: <20080714164948.GA15153@suse.de>
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jon Masters <jonathan@jonmasters.org>,
	Stefan Assmann <sassmann@suse.de>,
	LKML <linux-kernel@vger.kernel.org>, Ihno Krumreich <ihno@suse.de>,
	Sven Dietrich <sdietrich@suse.de>, Daniel Gollub <dgollub@suse.de>,
	Felix Foerster <ffoerster@suse.de>
References: <12155255883170-git-send-email-od@suse.de> <20080713210133.GA12362@elte.hu> <200807140924.59023.jbarnes@virtuousgeek.org> <20080714164548.GA28499@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080714164548.GA28499@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-Jul-08, Ingo Molnar wrote:
> 
> * Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
> > > applied to tip/x86/pci-ioapic-boot-irq-quirks, thanks Olaf.
> > >
> > > Jesse, what do you think about this topic? We are keeping it 
> > > separate for the time being. They are not particularly pretty, but 
> > > being able to mask/unmask irqs (without generating those legacy IRQs 
> > > and creating an IRQ storm) is essential to -rt.
> > 
> > See my other reply; the branch looks good.  I agree that making sure 
> > -rt can work is an important feature.  My only concern is that this is 
> > touching so much hardware specific code that *something* is likely to 
> > break.  But as long as Olaf & co. can help track down any issues, I'm 
> > ok with it.
> 
> ok. We'll cook it a bit more in tip/master and then send it over to you 
> once all the dependent changes have gone upstream in the merge window, 
> ok? I think it's v2.6.27 worthy stuff - nicely localized, sufficiently 
> finegrained and any problems with it has to be debugged the hard way by 
> exposing people to them ...

Ack. :)

Thanks,

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

