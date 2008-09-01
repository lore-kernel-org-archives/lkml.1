Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbYIAWCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbYIAWCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 18:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbYIAWCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 18:02:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750821AbYIAWCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 18:02:42 -0400
Date: Mon, 1 Sep 2008 15:02:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
In-Reply-To: <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0809011500460.12958@nehalem.linux-foundation.org>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Sep 2008, Thomas Gleixner wrote:
> 
> The CPU calibration of < 2.6.27 is against PIT and does _NOT_ give me a
> pretty good estimation for TSC.

Umm. Which one. The 32-bit or the 64-bit?

I already pointed out that the 64-bit PIT calibration is pure and utter 
GARBAGE. And I pointed out that the 32-bit one is a lot smarter.

> I was pretty happy when Alok beat me to unify the TSC calibration code
> as it solved one of my long standing todo items, which also filled my
> buglist on a regular base.

The problem is that he unified it around the _worse_ code.

			Linus
