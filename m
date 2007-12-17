Return-Path: <linux-kernel-owner+w=401wt.eu-S936028AbXLQMPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936028AbXLQMPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 07:15:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbXLQMP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 07:15:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35633 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbXLQMP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 07:15:27 -0500
Date: Mon, 17 Dec 2007 13:15:56 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Kyle McMartin <kyle@mcmartin.ca>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: RFC: remove __read_mostly
Message-ID: <20071217121556.GA31999@one.firstfloor.org>
References: <20071213222044.GH21616@stusta.de> <20071213235432.GA26669@fattire.cabal.ca> <p73tzmmf72u.fsf@bingen.suse.de> <20071217023339.ce3da56c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071217023339.ce3da56c.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So...  once we've moved all read-mostly variables into __read_mostly, what
> is left behind in bss?

I had already covered that in the next paragraph which you conveniently
snipped :)

Anyways I suspect the right solution for that would be more classes
of variables for even better grouping.

And for really often writen variables cache line padding is probably a good
idea.

-Andi
