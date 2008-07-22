Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbYGVF6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbYGVF6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbYGVF6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:58:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:59700 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbYGVF6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:58:05 -0400
Subject: Re: [git pull] x86: declaration fixes
From: Jaswinder Singh <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080721180439.GA13720@elte.hu>
References: <1216662432.28271.30.camel@jaswinder.satnam>
	 <20080721180439.GA13720@elte.hu>
Content-Type: text/plain
Date: Tue, 22 Jul 2008 11:27:01 +0530
Message-Id: <1216706221.2595.8.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

On Mon, 2008-07-21 at 20:04 +0200, Ingo Molnar wrote:
> * Jaswinder Singh <jaswinder@infradead.org> wrote:
> 

> another thing:
> 
> --- a/include/asm-x86/signal.h
> +++ b/include/asm-x86/signal.h
> 
> +void do_notify_resume(struct pt_regs *, void *, __u32);
> +
> 
> please add "extern" to each such prototype declaration. (the same is 
> true for a handful of other prototypes you've added - please re-review 
> and fix them)
> 

I was trying to follow other functions declaration in the file.

function declaration without extern :-

http://git.infradead.org/users/jaswinder/linux-2.6-tip.git?a=commitdiff;h=f740a1e1bbee2ce8a0b1b97361771db40afc37d2
http://git.infradead.org/users/jaswinder/linux-2.6-tip.git?a=commitdiff;h=b7b5113220da95eaa8b75ebd5bbd5278eed122e5

function declaration with extern :-

http://git.infradead.org/users/jaswinder/linux-2.6-tip.git?a=commitdiff;h=8cac4294a5e9b036c30d30e2e894e74201ee1c6b
http://git.infradead.org/users/jaswinder/linux-2.6-tip.git?a=commitdiff;h=e7d3d48dbf3e517e2e827a2adc6a2f861b16e6a6
http://git.infradead.org/users/jaswinder/linux-2.6-tip.git?a=commitdiff;h=feb49274338051ddf11d16f67b08ee6cafb32dbf

But you are emphasizing to use extern for all function declarations.

With current gcc, I think using extern with function declaration is :-
1. Wastage of time
2. Wastage of energy
3. Increase file size with 7 bytes for each extern.

If there is any secret behind using extern in kernel header files.
Please let me know.

Thank you,

Jaswinder Singh.

