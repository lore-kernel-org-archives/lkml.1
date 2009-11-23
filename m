Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbZKWS03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbZKWS03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 13:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZKWS02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 13:26:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58658 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbZKWS02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 13:26:28 -0500
Date: Mon, 23 Nov 2009 19:25:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] x86: UV SGI, Don't track GRU space in PAT
Message-ID: <20091123182520.GA24482@elte.hu>
References: <20091029184723.GA562@sgi.com>
 <20091108120609.GW11372@elte.hu>
 <20091117212318.GA21137@sgi.com>
 <4B0321F9.5060308@zytor.com>
 <20091119202341.GA4420@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091119202341.GA4420@sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jack Steiner <steiner@sgi.com> wrote:

> GRU space is always mapped as WB in the page table. There is
> no need to track the mappings in the PAT. This also eliminates
> the "freeing invalid memtype" messages when the GRU space is unmapped.
> 
> Signed-off-by: Jack Steiner <steiner@sgi.com>
> 
> ---
> Version 2 with changes suggested by Ingo (at least I think I understood what
> he wanted).
> 
> Version 3 with changes suggested by Peter to make the new function
> a member of the x86_platform structure.

thanks, it looks much cleaner now. I've applied it to tip:x86/mm.

	Ingo
