Return-Path: <linux-kernel-owner+w=401wt.eu-S1760924AbZBXWSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760924AbZBXWSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 17:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758690AbZBXWSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 17:18:30 -0500
Received: from smtp2.Stanford.EDU ([171.67.219.82]:46231 "EHLO
	smtp2.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756935AbZBXWS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 17:18:29 -0500
Subject: Re: [Announce] 2.6.29-rc6-rt2
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Fernando Pablo Lopez-Lezcano <nando@ccrma.Stanford.EDU>
In-Reply-To: <alpine.LFD.2.00.0902241729590.3523@localhost.localdomain>
References: <1235437021.4462.25.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0902241120320.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241729590.3523@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 24 Feb 2009 14:18:15 -0800
Message-Id: <1235513895.3816.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-24 at 17:30 +0100, Thomas Gleixner wrote:
> On Tue, 24 Feb 2009, Thomas Gleixner wrote:
> > >  [<c0440ef1>] internal_add_timer+0x88/0x8c
> > 
> > Can you try to enable the following config options:
> > 
> > CONFIG_DEBUG_OBJECTS
> > CONFIG_DEBUG_OBJECTS_FREE
> > CONFIG_DEBUG_OBJECTS_TIMERS
> > CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT
> 
> Don't bother. Just noticed that this is nf_conntrack context. Working
> on that right now.

I'm running rc6-rt3 and that problem seem to be gone (uptime of 2.5
hours in my desktop, 1.33 hours on my laptop, both running FC9 with a
2.6.29 version of the Planet CCRMA rt kernel). So far so good!

Thanks!!
-- Fernando


