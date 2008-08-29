Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbYH2RGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbYH2RGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 13:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758078AbYH2RGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 13:06:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54892 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757519AbYH2RGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 13:06:10 -0400
Date: Fri, 29 Aug 2008 19:08:51 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Gregory Haskins <gregory.haskins@gmail.com>, mingo@elte.hu,
       rostedt@goodmis.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: [PATCH] seqlock: serialize against writers
Message-ID: <20080829170851.GZ26610@one.firstfloor.org>
References: <20080829154237.1196.66825.stgit@dev.haskins.net> <87abevpzv7.fsf@basil.nowhere.org> <48B81F60.3080409@gmail.com> <20080829162216.GW26610@one.firstfloor.org> <48B823F6.1010509@novell.com> <20080829163749.GX26610@one.firstfloor.org> <48B826BD.9000308@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B826BD.9000308@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No idea on the problem itself because I don't understand it, just:

> Given that, we either need to address the const requirement
> for userspace, alter userspace's usage, or find another way to address
> the deadlock.  Any ideas?

In the worst case you can always disable the vsyscall gtod() and
thus the need for a user space safe seqlock_t, but it will
hurt some workloads significantly. 

-Andi

