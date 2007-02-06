Return-Path: <linux-kernel-owner+w=401wt.eu-S965310AbXBFTHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965310AbXBFTHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 14:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965329AbXBFTHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 14:07:40 -0500
Received: from www.osadl.org ([213.239.205.134]:35455 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965310AbXBFTHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 14:07:38 -0500
Subject: Re: 2.6.20-rc6-mm3
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Walker <dwalker@mvista.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <1170787543.9781.362.camel@imap.mvista.com>
References: <20070129204528.eb8d695e.akpm@osdl.org>
	 <1170777802.9781.353.camel@imap.mvista.com> <1170786992.3785.0.camel@chaos>
	 <1170787543.9781.362.camel@imap.mvista.com>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 20:07:50 +0100
Message-Id: <1170788870.3785.9.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 10:45 -0800, Daniel Walker wrote:
> > > -rt tree also .. I haven't done a bisect , but I'm assuming this is HRT
> > > related ..
> > 
> > And why should it increment ? Is there a rule that it has to ?
> 
> I don't know .. I would imagine some users might look at it and wonder
> why there timer isn't ticking (I know it actually is ticking , but they
> don't), when it has is every other kernel. 

What kind of artificial problem are you creating here ?

> We could just remove the timer entry .

No we can't. The timer interrupt is setup and it does not go away, as we
keep the PIT as a backup for the broken lapics.

	tglx




