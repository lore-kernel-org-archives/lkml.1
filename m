Return-Path: <linux-kernel-owner+w=401wt.eu-S1752698AbYKRLRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbYKRLRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 06:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbYKRLRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 06:17:16 -0500
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:28751 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbYKRLRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 06:17:15 -0500
Date: Tue, 18 Nov 2008 12:16:33 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>, Glauber Costa <gcosta@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       heukelum@fastmail.fm
Subject: Re: [RFC,v2] x86_64: save_args out of line
Message-ID: <20081118111633.GA21036@mailshack.com>
References: <1226845741-12470-2-git-send-email-heukelum@fastmail.fm> <20081117175232.GA13766@mailshack.com> <49228648.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49228648.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Tue, 18 Nov 2008 12:16:35 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.31; VDF: 7.1.0.98; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2008 at 08:09:28AM +0000, Jan Beulich wrote:
> >>> Alexander van Heukelum <heukelum@mailshack.com> 17.11.08 18:52 >>>
> >The macro "interrupt" in entry_64.S generates a lot of code and it
> >is used more and more often. This patch moves most of its contents
> >into an external function. This saves anywhere between 500 and 2500
> >bytes of text depending on the configuration.
> 
> Without numbers, I'd doubt that the code size reduction outweighs the
> overhead of the extra call. Did you do any measurements?

I have not measured yet. I'll see if I can highjack a machine. What
kind of benchmark would you suggest?

> >Dwarf2-annotations are most probably wrong or missing at all.
> 
> Indeed - do you have intentions to address this?

Yes, I'ld like to get it right. What do you use to check the
annotations?

Greetings,
	Alexander

> Jan
> 
