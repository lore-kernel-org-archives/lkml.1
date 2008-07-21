Return-Path: <linux-kernel-owner+w=401wt.eu-S1752865AbYGUQbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbYGUQbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 12:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbYGUQbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 12:31:36 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:58757 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbYGUQbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:31:36 -0400
Subject: Re: [git pull] scheduler updates for v2.6.27, phase #2
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080721153804.GA26072@elte.hu>
References: <20080721153804.GA26072@elte.hu>
Content-Type: text/plain; charset=utf-8
Date: Mon, 21 Jul 2008 09:31:32 -0700
Message-Id: <1216657892.2294.34.camel@dhcp32.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-21 at 17:38 +0200, Ingo Molnar wrote:
> Linus,
> 
> Please pull the latest sched/for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched/for-linus
> 
> this includes the cpu_active_map changes (which cleans up scheduler and 
> CPU hotplug interaction) and Peter's hrtick cleanup (which fixes the 
> uvesafb regression) and assorted fixlets.


I get this warning on powerpc builds (linus git as of a few days ago), 

/localuser/dwalker/linus/kernel/sched_rt.c: In function ‘do_balance_runtime’:
/localuser/dwalker/linus/kernel/sched_rt.c:256: warning: comparison of distinct pointer types lacks a cast

I'm not exactly sure why .. Did this get fixed already?

Daniel

