Return-Path: <linux-kernel-owner+w=401wt.eu-S1423172AbXBBHV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423172AbXBBHV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 02:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423178AbXBBHVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 02:21:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:58412 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423175AbXBBHV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 02:21:27 -0500
From: Andi Kleen <ak@suse.de>
To: Vojtech Pavlik <vojtech@suse.cz>
Subject: Re: [patch 9/9] Make use of the Master Timer
Date: Fri, 2 Feb 2007 08:05:15 +0100
User-Agent: KMail/1.9.5
Cc: Jiri Bohac <jbohac@suse.cz>, linux-kernel@vger.kernel.org,
       ssouhlal@freebsd.org, arjan@infradead.org, tglx@linutronix.de,
       johnstul@us.ibm.com, zippel@linux-m68k.org, andrea@suse.de
References: <20070201095952.589234000@jet.suse.cz> <20070201142927.GR21755@dwarf.suse.cz> <20070201152340.GA20792@suse.cz>
In-Reply-To: <20070201152340.GA20792@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702020805.16059.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Hmm, I wasn't sure. Why is it needed? How outdated can the
> > result of RDTSC / RDTSCP be?
> > 
> > If I do:
> > 	rdtscll(a)
> > 	...
> > 	rdtscll(b)
> > is it guaranteed that (b > a) ?
> 
> On a single CPU this is always guaranteed. Even on AMD.

It's not guaranteed on Intel at least (but happens to work on P4) 

-Andi
