Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbYGNRdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbYGNRdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 13:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYGNRdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 13:33:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44398 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbYGNRdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 13:33:42 -0400
Date: Mon, 14 Jul 2008 19:51:37 +0200
From: Olaf Dabrunz <od@suse.de>
To: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Stefan Assmann <sassmann@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Ihno Krumreich <ihno@suse.de>, Sven Dietrich <sdietrich@suse.de>,
       Daniel Gollub <dgollub@suse.de>, Felix Foerster <ffoerster@suse.de>
Subject: Re: [PATCH 0/3] Boot IRQ quirks for Broadcom and AMD/ATI
Message-ID: <20080714175137.GA2297@suse.de>
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jon Masters <jonathan@jonmasters.org>,
	Stefan Assmann <sassmann@suse.de>,
	LKML <linux-kernel@vger.kernel.org>, Ihno Krumreich <ihno@suse.de>,
	Sven Dietrich <sdietrich@suse.de>, Daniel Gollub <dgollub@suse.de>,
	Felix Foerster <ffoerster@suse.de>
References: <12155255883170-git-send-email-od@suse.de> <20080713210133.GA12362@elte.hu> <200807140924.59023.jbarnes@virtuousgeek.org> <20080714164548.GA28499@elte.hu> <20080714164948.GA15153@suse.de> <20080714165823.GB15153@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080714165823.GB15153@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-Jul-08, Olaf Dabrunz wrote:
> I am working on a consolidated patch set for AKMP. It integrates all
> fixes and adds a config option CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS
> (prepared by Stefan Assmann), which can default to off for vanilla and to
> on for RT / threaded IRQ handling. This means that the whole patchset
> can (in principle) be applied to vanilla and RT without change. Also
> CONFIG_PREEMPT_HARDIRQ can "select CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS".
> 
> If you don't mind, I will send the full set out today.

On second thought and after talking to Stefan, as you think the patches
can go into 2.6.27 as they are, there is not much benefit in integrating
the fixes and the config option patch. Stefan will commit the config
option patch to tip tomorrow.

Thanks,

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

