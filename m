Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbXIBSle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbXIBSle (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 14:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbXIBSl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 14:41:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:32910 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbXIBSl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 14:41:26 -0400
Date: Sun, 2 Sep 2007 11:40:17 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Christian Leber <christian@leber.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux, 2.6.23-rc5, powersaving degradation, (time spend in C0
 goes up after a while)
Message-ID: <20070902114017.15800e42@laptopd505.fenrus.org>
In-Reply-To: <20070902174038.GA10877@core>
References: <20070902174038.GA10877@core>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Sep 2007 19:40:38 +0200
Christian Leber <christian@leber.de> wrote:

> Hello,
> 
> I have observed some oddness in the powersaving behavior in rc5 and
> the rcs before and i suspect this may be scheduler related.
> 
> After booting or resuming from drisk or ram(!) the wakeups are about
> 45 per second (about 1% C0 (cpu runng)) and after
> about half an hour to hours of doing nothing with the laptop besides
> having a powertop in konsole the wakeups rise to about 6200 and the
> cpu is running 55% of the time.
> 
> (with rc3 this was odder, it took three time pretty exactly 43min
> until this occured)
> 
> I appended the output of powertop and the .config.
> But powertop doesn't even show the reason for the wakeups, probably
> they don't exist, but the power usage really goes up.
> 
> The hardware is btw. Dell latitude d830 (intel T7300, intel wlan and
> gfx)
> 

can you give us an lspci -vvxx of the system when it's in this "bad"
state? We have a very vague suspicion on something like this, the lspci
would help us a lot (this is a really rare thing that we can't really
reproduce, but it has been reported a few times before)
