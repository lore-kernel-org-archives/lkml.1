Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbYCVWFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbYCVWFk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 18:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbYCVWFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 18:05:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53351
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750916AbYCVWFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 18:05:31 -0400
Date: Sat, 22 Mar 2008 15:05:40 -0700 (PDT)
Message-Id: <20080322.150540.07038826.davem@davemloft.net>
To: tglx@linutronix.de
Cc: chrisw@sous-sol.org, linux-kernel@vger.kernel.org, stable@kernel.org,
       jejb@kernel.org, jmforbes@linuxtx.org, zwane@arm.linux.org.uk,
       tytso@mit.edu, rdunlap@xenotime.net, davej@redhat.com,
       chuckw@quantumlinux.com, reviews@ml.cw.f00f.org, mkrufky@linuxtv.org,
       cebbert@redhat.com, cavokz@gmail.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, mingo@elte.hu,
       buytenh@wantstofly.org, riku.voipio@movial.fi, gregkh@suse.de
Subject: Re: [patch 33/76] futex: runtime enable pi and robust functionality
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.00.0803220833040.3781@apollo.tec.linutronix.de>
References: <20080321224250.144333319@sous-sol.org>
	<20080321224400.674465387@sous-sol.org>
	<alpine.LFD.1.00.0803220833040.3781@apollo.tec.linutronix.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 22 Mar 2008 08:37:07 +0100 (CET)

> On Fri, 21 Mar 2008, Chris Wright wrote:
> 
> > -stable review patch.  If anyone has any objections, please let us know.
> > ---------------------
> 
> For this one you need the S390 fixes:

And sparc64 needed similar fixes, but they did get submitted in time
thankfully.

I think this futex change should have gotten more exposure, and proper
coordination with arch maintainers so that it didn't go into -stable
unless the necessary arch level fixups were known to go in at the same
time.
