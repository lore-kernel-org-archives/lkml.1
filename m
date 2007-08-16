Return-Path: <linux-kernel-owner+w=401wt.eu-S932991AbXHPWk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbXHPWk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 18:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762013AbXHPWkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 18:40:20 -0400
Received: from ozlabs.org ([203.10.76.45]:53666 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761995AbXHPWkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 18:40:17 -0400
Subject: Re: [PATCH/RFC 3/4]Introduce "account modifiers" mechanism
From: Rusty Russell <rusty@rustcorp.com.au>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: kvm-devel@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>,
       virtualization <virtualization@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <46C4740F.2050701@bull.net>
References: <46C4719A.2060308@bull.net> <46C4720F.7030304@bull.net>
	 <46C4725A.4070607@bull.net>  <46C4740F.2050701@bull.net>
Content-Type: text/plain
Date: Fri, 17 Aug 2007 08:39:15 +1000
Message-Id: <1187303955.6449.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-16 at 17:58 +0200, Laurent Vivier wrote:
> [PATCH 3/3] introduce "account modifiers" mechanism in the kernel allowing a
> module to modify the collected accounting for a given task. This implementation
> is based on the "preempt_notifier". "account_system_time()" and
> "account_user_time()" can call functions registered by a module to modify the
> cputime value.
> 
> Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>


Hi Laurent,

	This seems a little like overkill.  Why not just add an
"account_guest_time" which subtracts the given amount of time from
system time (if available) and adds it to guest time?  Then kvm (and
lguest) should just need to call this at the right times.

Am I missing something?
Rusty.


