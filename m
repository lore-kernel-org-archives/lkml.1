Return-Path: <linux-kernel-owner+w=401wt.eu-S1752471AbYIEKOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbYIEKOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 06:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbYIEKOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 06:14:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:59103 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbYIEKOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 06:14:41 -0400
Subject: Re: [patch] Add basic sanity checks to the syscall execution patch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: pageexec@freemail.hu
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de,
       hpa@zytor.org
In-Reply-To: <48C0FF43.30940.2C3EFC0@pageexec.freemail.hu>
References: <20080903195122.73905236@infradead.org>
	 , <873akgw251.fsf@basil.nowhere.org>
	 , <20080904054444.79e71974@infradead.org>
	 <48C0FF43.30940.2C3EFC0@pageexec.freemail.hu>
Content-Type: text/plain
Date: Fri, 05 Sep 2008 20:14:07 +1000
Message-Id: <1220609647.4879.169.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-05 at 11:43 +0200, pageexec@freemail.hu wrote:
> > I'd have considered taking your email serious if you had left out the
> > uncalled and unneeded sarcasm line at the end.
> 
> consider how your whole patch is based on one big self-contradiction.
> you already assume that the attacker *can* modify arbitrary kernel memory
> (even the otherwise *read-only* syscall table at that), but at the very
> same time you're saying he *can't* use the same powers to patch out your
> 'protection' or do many other things to evade it. as it is, it's cargo cult
> security at its best, reminding one on the Vista kernel's similar 'protection' 
> mechanism for the service descriptor tables...

Well, I see it a different way ... it will once for all screw up
binary modules that try to add syscalls :-)

Ben.

