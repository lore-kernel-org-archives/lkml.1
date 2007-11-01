Return-Path: <linux-kernel-owner+w=401wt.eu-S1760255AbXKAOGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255AbXKAOGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 10:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbXKAOGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 10:06:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48929 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbXKAOGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 10:06:10 -0400
Subject: Re: [patch 1/4] spinlock: lockbreak cleanup
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       riel <riel@redhat.com>
In-Reply-To: <20071101140241.GB26879@wotan.suse.de>
References: <20071101140146.GA26879@wotan.suse.de>
	 <20071101140241.GB26879@wotan.suse.de>
Content-Type: text/plain
Date: Thu, 01 Nov 2007 15:06:05 +0100
Message-Id: <1193925965.27652.284.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-01 at 15:02 +0100, Nick Piggin wrote:

> Rename need_lockbreak to spin_needbreak, make it use spin_is_contended to
> decouple it from the spinlock implementation, and make it typesafe (rwlocks
> do not have any need_lockbreak sites -- why do they even get bloated up
> with that break_lock then?).

IIRC Lee has a few patches floating about that do introduce lockbreak
stuff for rwlocks.


