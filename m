Return-Path: <linux-kernel-owner+w=401wt.eu-S1760723AbYBNQkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760723AbYBNQkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 11:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbYBNQkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 11:40:23 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46361 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbYBNQkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 11:40:23 -0500
Date: Thu, 14 Feb 2008 18:16:03 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, torvalds@osdl.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, ying.huang@intel.com
Subject: Re: [PATCH] Fix left over EFI cache mapping problems
Message-ID: <20080214171603.GC16255@one.firstfloor.org>
References: <20080214131317.GA27769@basil.nowhere.org> <20080214161218.GA28152@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214161218.GA28152@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> this is indeed a bug (we change the attributes for a larger area than 
> needed), but your fix is unclean. Find below a cleaner solution.

You're still ignoring the other problem of set_memory_uc() not 
handling fixmap and ioremap correctly. I explained it to you
several times now and you have not replied to it once. If you
think my analysis of this is wrong please describe exactly
where it is wrong.

Sure if you're only fixing half the bugs you get a simpler patch,
but you also still got half the bugs.

-Andi
