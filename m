Return-Path: <linux-kernel-owner+w=401wt.eu-S1757614AbYILTQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbYILTQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 15:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755650AbYILTQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 15:16:10 -0400
Received: from www.tglx.de ([62.245.132.106]:44374 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755580AbYILTQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 15:16:09 -0400
Date: Fri, 12 Sep 2008 21:15:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.27-rc6: nohz + s2ram = need to press keys to get progress
In-Reply-To: <200809122117.05750.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.10.0809122113270.13819@apollo.tec.linutronix.de>
References: <20080912083113.GA1625@elf.ucw.cz> <200809122117.05750.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2008, Rafael J. Wysocki wrote:

> On Friday, 12 of September 2008, Pavel Machek wrote:
> > Hi!
> > 
> > The old "you have to press keys to get machine to progress" seems to
> > be back :-(. Thinkpad x60.
> 
> I guess the last bunch of HPET/clockevents patches caused that to happen.

Guessing is hardly a good method to get down to the root cause of
those problems.
 
> We seem to be doing a "one step forward, one step back" thing here ...

Well, the fixes for HPET/clockevents fix real bugs and there are no
evident side effects vs. s2ram inside. quite the contrary.

Thanks,

	tglx
