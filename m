Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbZCQTVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbZCQTVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 15:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbZCQTU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 15:20:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54483
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752953AbZCQTU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 15:20:56 -0400
Date: Tue, 17 Mar 2009 12:20:42 -0700 (PDT)
Message-Id: <20090317.122042.72714328.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: mega@retes.hu, oleg@redhat.com, davidel@xmailserver.org, mingo@elte.hu,
       roland@redhat.com, akpm@linux-foundation.org, cfriesen@nortel.com,
       linux-kernel@vger.kernel.org
Subject: Re: Q: SEGSEGV && uc_mcontext->ip
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0903170848490.3082@localhost.localdomain>
References: <20090317041337.GA29740@redhat.com>
	<200903170923.56430.mega@retes.hu>
	<alpine.LFD.2.00.0903170848490.3082@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 Mar 2009 08:56:34 -0700 (PDT)

> What you might be able to do instead is to walk signal frames backwards by 
> hand. IOW, accept the fact that sometimes signals end up being nested, but 
> then you could try to find the right frame by just looking at them.

FWIW, GCC's dwarf2 unwind handlers already know how to walk through
Linux signal frames and identify them.
