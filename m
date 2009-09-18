Return-Path: <linux-kernel-owner+w=401wt.eu-S1753594AbZIRQRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbZIRQRN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 12:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbZIRQRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 12:17:12 -0400
Received: from outbound-mail-111.bluehost.com ([69.89.18.7]:56394 "HELO
	outbound-mail-111.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752476AbZIRQRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 12:17:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=W2sZcMsCY4kxE2uBg4/5Y/xVm2bcJ+0zSpyjtDGGoYP08OBPuEqyPvdoOCNduEJ2v1wCo3Ijh4rx2eEpATllSQN7Xd5yPkIKlu5kbf67rhMR2FoqdAevh3mfpxmQgpBJ;
Date: Fri, 18 Sep 2009 09:17:05 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Tejun Heo <tj@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] first round of PCI updates for 2.6.32
Message-ID: <20090918091705.65478530@jbarnes-g45>
In-Reply-To: <20090918155247.GA20347@elte.hu>
References: <20090915132105.2fdd1d45@jbarnes-g45>
	<20090917173012.GA11155@elte.hu>
	<20090917103614.6ab1385f@jbarnes-g45>
	<20090917175944.GA17304@elte.hu>
	<20090918082715.6272a262@jbarnes-g45>
	<20090918155247.GA20347@elte.hu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009 17:52:47 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
> > On Thu, 17 Sep 2009 19:59:44 +0200
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > > 
> > > > On Thu, 17 Sep 2009 19:30:12 +0200
> > > > Ingo Molnar <mingo@elte.hu> wrote:
> > > > 
> > > > > 
> > > > > * Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > 
> > > > > Config and full bootlog attached.
> > > > > 
> > > > > Note:
> > > > > 
> > > > >  CONFIG_DEBUG_PER_CPU_MAPS=y
> > > > >  CONFIG_CPUMASK_OFFSTACK=y
> > > > 
> > > > Does this patch fix it?  I sent it to you earlier but I never
> > > > heard back...
> > > 
> > > Ah ... you probably sent it in the merge window communication
> > > blackout ;-)
> > > 
> > > Will try, thanks.
> > 
> > Did you get a chance to try this patch yet Ingo?
> 
> Yeah, it does - thanks.
> 

Thanks for testing, just pushed out the fix to my tree.

-- 
Jesse Barnes, Intel Open Source Technology Center
