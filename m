Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbYIYMgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbYIYMgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbYIYMgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 08:36:14 -0400
Received: from mail.transmode.se ([83.241.175.147]:22455 "EHLO
	mail.transmode.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbYIYMgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 08:36:13 -0400
Subject: Re: UIO device name
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Reply-To: joakim.tjernlund@transmode.se
To: Paul Mundt <lethal@linux-sh.org>
Cc: Ben Nizette <bn@niasdigital.com>, "Hans J. Koch" <hjk@linutronix.de>,
       gregkh@suse.de, Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080925115337.GA9334@linux-sh.org>
References: <20080924093551.GB7591@linux-sh.org>
	 <1222250279.12624.195.camel@gentoo-jocke.transmode.se>
	 <20080924102230.GB2973@local>
	 <1222255981.12624.215.camel@gentoo-jocke.transmode.se>
	 <20080924114743.GA9694@linux-sh.org>
	 <1222259894.12624.247.camel@gentoo-jocke.transmode.se>
	 <1222297057.4037.12.camel@moss.renham>
	 <1222337151.12624.293.camel@gentoo-jocke.transmode.se>
	 <1222339729.3938.15.camel@moss.renham>
	 <1222342868.12624.304.camel@gentoo-jocke.transmode.se>
	 <20080925115337.GA9334@linux-sh.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Transmode AB
Date: Thu, 25 Sep 2008 14:36:11 +0200
Message-Id: <1222346171.12624.326.camel@gentoo-jocke.transmode.se>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-25 at 20:53 +0900, Paul Mundt wrote:
> On Thu, Sep 25, 2008 at 01:41:08PM +0200, Joakim Tjernlund wrote:
> > On Thu, 2008-09-25 at 20:48 +1000, Ben Nizette wrote:
> > > UIO is an interface type, not a bus type.  UIO isn't a subsystem as
> > > such, it's a user interface.  If the interface is consistent (even if
> > > the backing device is different) I don't see the problem with consistent
> > > naming.
> > 
> > Do you see a problem with letting the protocol driver choose another
> > one? Why not offer the user the chance to let the name mean something?
> > 
> This thread is still going? Amazing. Anyways, your protocol driver
> argument doesn't make any sense. Take the case of uio_pdrv or the genirq
> variant. This is the name it hands off to the core, while the devices
> that register underneath it all have their own names set. Go grep for all
> instances of uio_pdrv platform data in the architecture code. I'm getting
> the impression you haven't actually even bothered to look at the name
> entries.

Thanks for your kind words. It is true that I am not an expert in this
area, just trying to understand and improve. Obviously I still lack 
some knowledge but now I am done with uio's interface naming, I will
just scan sysfs for it. 

 Jocke
