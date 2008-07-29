Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbYG2AoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbYG2AoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 20:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbYG2AoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 20:44:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35244
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751034AbYG2AoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 20:44:16 -0400
Date: Mon, 28 Jul 2008 17:44:15 -0700 (PDT)
Message-Id: <20080728.174415.154327359.davem@davemloft.net>
To: mingo@elte.hu
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: combinatorial explosion in lockdep
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080728235133.GA7956@elte.hu>
References: <20080728.153702.103032029.davem@davemloft.net>
	<20080728.161318.38361710.davem@davemloft.net>
	<20080728235133.GA7956@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 29 Jul 2008 01:51:33 +0200

> Any chance to get the "cat /proc/lockdep*" output, so that we could see 
> and check the expected behavior of the full graph?

/proc/lockdep loops forever in count_forward_deps() :-)

I was able to capture a copy of lockdep_chains:

http://vger.kernel.org/~davem/lockdep_chains.bz2
