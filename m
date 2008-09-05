Return-Path: <linux-kernel-owner+w=401wt.eu-S1753634AbYIELSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbYIELSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 07:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbYIELS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 07:18:26 -0400
Received: from r00tworld.com ([212.85.137.21]:41167 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbYIELSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 07:18:25 -0400
From: pageexec@freemail.hu
To: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>
Date: Fri, 05 Sep 2008 11:43:31 +0200
MIME-Version: 1.0
Subject: Re: [patch] Add basic sanity checks to the syscall execution patch
Reply-to: pageexec@freemail.hu
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de, hpa@zytor.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Message-ID: <48C0FF43.30940.2C3EFC0@pageexec.freemail.hu>
In-reply-to: <20080904054444.79e71974@infradead.org>
References: <20080903195122.73905236@infradead.org>, <873akgw251.fsf@basil.nowhere.org>, <20080904054444.79e71974@infradead.org>
X-mailer: Pegasus Mail for Windows (4.50 PB1)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Fri, 05 Sep 2008 11:43:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 Sep 2008 at 5:44, Arjan van de Ven wrote:

> On Thu, 04 Sep 2008 14:01:46 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Arjan van de Ven <arjan@infradead.org> writes:
> > 
> > > Add basic sanity checks to the syscall execution patch
> > 
> > This just means that the root kits will switch to patch
> > the first instruction of the entry points instead.
> > 
> > So the protection will be zero to minimal, but the overhead will
> > be there forever.
> > 
> > Now that I said this I expect it to go in yesterday.
> >
> 
> I'd have considered taking your email serious if you had left out the
> uncalled and unneeded sarcasm line at the end.

consider how your whole patch is based on one big self-contradiction.
you already assume that the attacker *can* modify arbitrary kernel memory
(even the otherwise *read-only* syscall table at that), but at the very
same time you're saying he *can't* use the same powers to patch out your
'protection' or do many other things to evade it. as it is, it's cargo cult
security at its best, reminding one on the Vista kernel's similar 'protection' 
mechanism for the service descriptor tables...

