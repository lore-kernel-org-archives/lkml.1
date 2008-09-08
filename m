Return-Path: <linux-kernel-owner+w=401wt.eu-S1753017AbYIHQPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbYIHQPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 12:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYIHQPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 12:15:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33569 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbYIHQPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 12:15:41 -0400
Message-ID: <48C54FA0.10302@kernel.org>
Date: Mon, 08 Sep 2008 09:15:28 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, linux@sandersweb.net,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
References: <200808311422.12525.linux@sandersweb.net> <200809071922.32974.linux@sandersweb.net> <48C48467.40703@zytor.com> <200809072249.17280.linux@sandersweb.net> <48C4A46B.90705@zytor.com> <alpine.LFD.1.10.0809080805240.3117@nehalem.linux-foundation.org> <20080908154535.GL26079@one.firstfloor.org> <48C54839.8050304@zytor.com> <alpine.LFD.1.10.0809080857450.3117@nehalem.linux-foundation.org> <48C54F1B.8040604@zytor.com>
In-Reply-To: <48C54F1B.8040604@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> 
> The issue at hand is that at least with the current toolchain, we need 
> to pass -march=generic in order for these instructions to be generated. 
>  We have an option for this, CONFIG_X86_GENERIC, which distributions 
> really *should* be using anyway.
> 

That should have been "-mtune=generic".  Sorry.

> And yes, it should be the default.  The patch I have makes it
> "default y" as well as change the help text.
> 
> Would it make you happier if this option was forced enabled unless 
> CONFIG_EMBEDDED was on?

I guess the other option is to create a new option for selecting the 
dangerous -mtune= variants, and possibly lock *that* option to 
CONFIG_EMBEDDED.

	-hpa
