Return-Path: <linux-kernel-owner+w=401wt.eu-S1760812AbYGAXoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760812AbYGAXoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 19:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbYGAXoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 19:44:24 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:28629 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbYGAXoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 19:44:23 -0400
Date: Wed, 2 Jul 2008 01:42:10 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Simple changes to make traps_32.c and traps_64.c more similar
Message-ID: <20080701234210.GA29962@mailshack.com>
References: <20080701193643.GA29695@mailshack.com> <20080701195004.GA27557@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701195004.GA27557@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Wed, 02 Jul 2008 01:44:00 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.0.59; VDF: 7.0.5.30; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 09:50:04PM +0200, Ingo Molnar wrote:
> nice. In terms of functionality, it is supposed to be a pure 
> no-changes-intended commit, correct?
> 
> In that case it makes sense to split it in two: in the first (larger) 
> bit put the things that are provably invariant on the .o and can be 
> verified that way.
> 
> In the second one, put the things that change the .o output slightly 
> (variable reordering can do that) - this we have to check more closely.
> 
> (One can normally do such a splitup by editing the raw diff and 
> splitting it in half that way - by sorting each chunk into the 
> appropriate target patch - and then making sure the end result is still 
> the same.)

Hi,

I ended up redoing it. The first patch has no influence on the generated
code; the second one does not change code size and the others are more
or less single logical changes.

I sent the patches as a reply to the original patch (replying to this one
would have been more logical... I need some sleep now). I tested compilation
and using qemu after patch 1, 2, and 7. They all run fine.

Greetings,
    Alexander

> 	Ingo
