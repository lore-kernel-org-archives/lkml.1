Return-Path: <linux-kernel-owner+w=401wt.eu-S1752295AbXBFT4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295AbXBFT4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 14:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbXBFT4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 14:56:46 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:46913 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbXBFT4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 14:56:45 -0500
Subject: Re: 2.6.20-rc6-mm3
From: Daniel Walker <dwalker@mvista.com>
Reply-To: dwalker@mvista.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <1170788870.3785.9.camel@chaos>
References: <20070129204528.eb8d695e.akpm@osdl.org>
	 <1170777802.9781.353.camel@imap.mvista.com> <1170786992.3785.0.camel@chaos>
	 <1170787543.9781.362.camel@imap.mvista.com> <1170788870.3785.9.camel@chaos>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 11:55:39 -0800
Message-Id: <1170791739.3455.3.camel@dwalker1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 20:07 +0100, Thomas Gleixner wrote:
> On Tue, 2007-02-06 at 10:45 -0800, Daniel Walker wrote:
> > > > -rt tree also .. I haven't done a bisect , but I'm assuming this is HRT
> > > > related ..
> > > 
> > > And why should it increment ? Is there a rule that it has to ?
> > 
> > I don't know .. I would imagine some users might look at it and wonder
> > why there timer isn't ticking (I know it actually is ticking , but they
> > don't), when it has is every other kernel. 
> 
> What kind of artificial problem are you creating here ?

I'm not trying to create anything .. However, as I said before
the /proc/interrupts "timer" entry doesn't work the same as it has in
other kernels.

If you think that isn't a problem then explain why ..

> > We could just remove the timer entry .
> 
> No we can't. The timer interrupt is setup and it does not go away, as we
> keep the PIT as a backup for the broken lapics.

Ok, how about adding the interrupts to the list which are driving the
timer ?

Daniel

