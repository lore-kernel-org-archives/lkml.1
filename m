Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbYJYGtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbYJYGtD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 02:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYJYGsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 02:48:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58523 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbYJYGsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 02:48:53 -0400
Date: Sat, 25 Oct 2008 08:56:27 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mike Travis <travis@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Machek <pavel@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Richard Purdie <rpurdie@rpsys.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] SGI X86 UV: Provide a System Activity Indicator	driver
Message-ID: <20081025065627.GI27492@one.firstfloor.org>
References: <4901AF28.4070606@sgi.com> <20081024120103.GD1680@elf.ucw.cz> <20081024120544.GA9812@elte.hu> <4901BF30.3090708@sgi.com> <87mygt9815.fsf@basil.nowhere.org> <490249CF.2080308@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490249CF.2080308@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Cool, thanks!  I rewrote the patch to use current->pid, removing the
> idle callback.

As a additional measure you could make the timer deferred when in 
idle state.  Then you would only actually do something when 
changing from idle to non idle or keeps being busy, but nothing 
when a CPU stays idle for a longer time.

The frequency wouldn't necessarily be 1 second then though.

-Andi
