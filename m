Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbYANQ5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbYANQ5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 11:57:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbYANQ4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 11:56:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53865 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbYANQ4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 11:56:47 -0500
Date: Mon, 14 Jan 2008 17:56:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: unify pagetable accessors patch causes double fault II
Message-ID: <20080114165635.GK15542@elte.hu>
References: <20080114094814.GA28300@basil.nowhere.org> <20080114125638.GA9510@basil.nowhere.org> <20080114130620.GA14057@elte.hu> <20080114135811.GA16190@one.firstfloor.org> <478B9183.3020101@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478B9183.3020101@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

>> This is with PAE and seems to only happen with enough RAM (6GB); a 
>> 2GB system boots. 64bit also works.
>
> Thanks, I'll have a close look at it.  Presumably a pfn is getting 
> truncated to 20/32-bits somewhere.

would be nice to have some debugging apparatus for bugs like this. 
Perhaps artificially add a large pfn, then convert/unconvert, then 
subtract it and expect the whole transformation to be an identity 
mapping? This way we could simulate most of the effects of >4GB RAM, 
right?

	Ingo
