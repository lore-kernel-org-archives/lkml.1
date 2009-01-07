Return-Path: <linux-kernel-owner+w=401wt.eu-S1757333AbZAGBiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbZAGBiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 20:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbZAGBiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 20:38:46 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57368 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbZAGBip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 20:38:45 -0500
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29 -mm merge plans
From: Andi Kleen <andi@firstfloor.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	<20090106225744.GA10553@infradead.org>
	<20090106151131.b6c4ff0b.akpm@linux-foundation.org>
	<20090106232418.GB25103@infradead.org>
	<20090107011448.GB3390@wotan.suse.de>
Date: Wed, 07 Jan 2009 02:38:45 +0100
In-Reply-To: <20090107011448.GB3390@wotan.suse.de> (Nick Piggin's message of "Wed, 7 Jan 2009 02:14:48 +0100")
Message-ID: <87tz8b3nfe.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> writes:
>
> I can't see a problem with putting a global mutex around sys_sync (almost
> by definition, any app in the last 10+ years that calls sys_sync is not
> performance critical).

Hmm, but sync() used to (is still?) livelocky and when it takes a
minute or so to flush (and I've seen that) do you really want any
other sync user to block for a minute too?

-Andi


-- 
ak@linux.intel.com
