Return-Path: <linux-kernel-owner+w=401wt.eu-S1760496AbYCZSgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760496AbYCZSgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 14:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756088AbYCZSgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 14:36:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754906AbYCZSgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 14:36:38 -0400
Date: Wed, 26 Mar 2008 11:33:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Gary Hade <garyhade@us.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Thomas Meyer <thomas@m3y3r.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, pm@debian.org
Subject: Re: [patch] pci: revert "PCI: remove transparent bridge sizing"
In-Reply-To: <20080326180701.GA6249@us.ibm.com>
Message-ID: <alpine.LFD.1.00.0803261132310.2775@woody.linux-foundation.org>
References: <47E8217C.9080400@s5r6.in-berlin.de> <20080325073117.GA8469@elte.hu> <20080325165007.GA7775@elte.hu> <47E94557.4030001@m3y3r.de> <20080325201125.GD15330@elte.hu> <20080325202954.GA22007@elte.hu> <47E969E1.6080608@m3y3r.de>
 <alpine.LFD.1.00.0803251445500.2775@woody.linux-foundation.org> <20080326101450.GA9060@jurassic.park.msu.ru> <20080326135458.GA27621@elte.hu> <20080326180701.GA6249@us.ibm.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 26 Mar 2008, Gary Hade wrote:
>
> I have a fix for the ThinkPad docking Oops but if the issue being
> discussed here is caused by the transparent bridge sizing removal
> change I totally agree that it should be reverted.  

Ok, I reverted it, but the docking Oops is still interesting, in that it 
implies that some piece of code wasn't exactly robust. I haven't seen the 
patch, but it sounds like that should be fixed independently..

		Linus
