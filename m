Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbZJZH0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbZJZH0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 03:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754810AbZJZH0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 03:26:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50884 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652AbZJZH0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 03:26:37 -0400
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] SGI x86_64 UV: Limit the number of processor bootup messages
From: Andi Kleen <andi@firstfloor.org>
References: <20091023233743.439628000@alcatraz.americas.sgi.com>
	<20091023233747.905291000@alcatraz.americas.sgi.com>
Date: Mon, 26 Oct 2009 08:26:41 +0100
In-Reply-To: <20091023233747.905291000@alcatraz.americas.sgi.com> (Mike Travis's message of "Fri, 23 Oct 2009 18:37:45 -0500")
Message-ID: <87d44ay5se.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis <travis@sgi.com> writes:

> Limit the number of processor bootup messages when
> system_state == SYSTEM_BOOTING.  Limit the number of
> offline messages when system is shutting down.

I think we should still have at least one line per CPU on bootup,
simply so that you have any clue what's going on when something hangs.

I agree the current lines of output is excessive.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
