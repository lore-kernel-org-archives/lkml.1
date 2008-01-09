Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbYAIOQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbYAIOQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 09:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYAIOQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 09:16:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60926 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbYAIOQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 09:16:37 -0500
Date: Wed, 9 Jan 2008 15:19:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: More breakage in native_rdtsc out of line in git-x86
Message-ID: <20080109141908.GB12855@one.firstfloor.org>
References: <20080109035534.GA30321@basil.nowhere.org> <20080109090956.GA14274@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109090956.GA14274@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> nope, it's a 64-bit setup/dependency bug/problem: the vsyscall mappings 
> are installed via an __initcall, and that's too late for early use. The 
> combo patch below fixed the crash for me, does it work on your box too?

That gives

/home/lsrc/quilt/linux/arch/x86/kernel/setup_64.c: In function 'setup_arch':
/home/lsrc/quilt/linux/arch/x86/kernel/setup_64.c:468: error: implicit declarati
on of function 'map_vsyscall'

But after I add a prototype to vsyscall.h it seems to work.

Just the barriers are still broken -- you have not replied to any 
of my emails on that topic. What's up with that?

-Andi
