Return-Path: <linux-kernel-owner+w=401wt.eu-S1765681AbYDOQ1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765681AbYDOQ1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 12:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbYDOQ1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 12:27:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52702 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbYDOQ1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 12:27:43 -0400
Message-ID: <4804D779.6070907@firstfloor.org>
Date: Tue, 15 Apr 2008 18:27:37 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Zijlstra <peterz@infradead.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Roland Dreier <rdreier@cisco.com>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>, Ingo Oeser <ioe-lkml@rameria.de>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace completions with semaphores
References: <20080411210022.GJ11962@parisc-linux.org>  <20080413125758.GQ11962@parisc-linux.org> <20080414153928.GA22259@elte.hu>  <adafxtoqvgh.fsf@cisco.com> <1208190749.7375.10.camel@twins>  <87d4osuy6r.fsf@basil.nowhere.org> <1208195673.7164.2.camel@twins>  <4803AD91.5020001@firstfloor.org>  <e2e108260804142318m19cf55c7p9973d3500de18120@mail.gmail.com>  <1208242017.7053.4.camel@lappy>  <e2e108260804150017u7d0aad8do9b26f7531a3a5226@mail.gmail.com> <1208249088.7124.7.camel@twins> <alpine.LFD.1.00.0804150907080.2879@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0804150907080.2879@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  - probably add support for completions to do counting

But that's just a semaphore, isn't it?

-Andi
