Return-Path: <linux-kernel-owner+w=401wt.eu-S965458AbXBFU42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965458AbXBFU42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 15:56:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965461AbXBFU42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 15:56:28 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:2529 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965458AbXBFU41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 15:56:27 -0500
Subject: Re: 2.6.20-rc6-mm3
From: Daniel Walker <dwalker@mvista.com>
Reply-To: dwalker@mvista.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070206205231.GA25430@elte.hu>
References: <20070129204528.eb8d695e.akpm@osdl.org>
	 <1170777802.9781.353.camel@imap.mvista.com> <1170786992.3785.0.camel@chaos>
	 <1170787543.9781.362.camel@imap.mvista.com> <1170788870.3785.9.camel@chaos>
	 <1170791739.3455.3.camel@dwalker1> <1170793206.3785.16.camel@chaos>
	 <1170794437.3455.20.camel@dwalker1>  <20070206205231.GA25430@elte.hu>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 12:56:18 -0800
Message-Id: <1170795378.3455.31.camel@dwalker1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 21:52 +0100, Ingo Molnar wrote:

> Well, if you enable dynticks you should expect the number of timer irqs 
> to go down. There's no problem here.

Ok .

> > The reason that I'm bringing it up at all is because people have ask 
> > me "Why isn't my timer ticking??"
> 
> it's quite easy to explain: because of the new dynticks feature. Both 
> 'timer' and 'LOC' counts go way down.

I don't have that enabled tho .. This is with HRT/dynamic tick both
off..


Daniel

