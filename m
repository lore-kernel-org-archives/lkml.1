Return-Path: <linux-kernel-owner+w=401wt.eu-S1751933AbYLWSfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbYLWSfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 13:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090AbYLWSfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 13:35:44 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46872 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbYLWSfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 13:35:43 -0500
Date: Tue, 23 Dec 2008 19:48:26 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Jaswinder Singh <jaswinder@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: traps.c replace #if CONFIG_X86_32 with #ifdef	CONFIG_X86_32
Message-ID: <20081223184826.GA496@one.firstfloor.org>
References: <1230049211.14358.2.camel@jaswinder.satnam> <49512BF5.2010705@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49512BF5.2010705@kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2008 at 10:20:37AM -0800, H. Peter Anvin wrote:
> >  		return;
> >  #endif
> 
> Applied to tip:x86/fpu, thanks.
> 
> Andi: you might have a perspective on this: in math_error() we bail out
> if there is no error on i386, but not on x86-64.  I am rather assuming
> that is because it simply can't happen on x86-64 (no IRQ 13 bullshit) so
> it wasn't necessary?

Probably yes because it was not needed. Don't remember the exact circumstances,
sorry.

But dropping the #ifdef should be fine obviously.

-Andi
-- 
ak@linux.intel.com
