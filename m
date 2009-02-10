Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbZBJN53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbZBJN53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 08:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbZBJN5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 08:57:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:59899 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515AbZBJN5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 08:57:05 -0500
Message-ID: <4991878C.9040802@kernel.org>
Date: Tue, 10 Feb 2009 22:56:28 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: hpa@zytor.com, jeremy@goop.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCHSET x86/master] add stack protector support for x86_32
References: <1234186798-16820-1-git-send-email-tj@kernel.org> <20090209135557.GB14785@elte.hu> <20090209140610.GA21560@elte.hu> <20090209203005.GA10473@elte.hu>
In-Reply-To: <20090209203005.GA10473@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 10 Feb 2009 13:56:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> Note that i spread the patches the following way: #001-003 are in tip:x86/urgent, 
> 
> FYI, -tip testing found this new build failure with MATH_EMU:
> 
> arch/x86/kernel/traps.c:904: error: conflicting types for 'math_emulate'
> /home/mingo/tip/arch/x86/include/asm/traps.h:80: error: previous declaration of 'math_emulate' was here

This is the missing asmlinkage one, right?

Thanks.

-- 
tejun
