Return-Path: <linux-kernel-owner+w=401wt.eu-S1753614AbZBCUyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbZBCUyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 15:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbZBCUyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 15:54:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751664AbZBCUyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 15:54:35 -0500
Date: Tue, 3 Feb 2009 12:53:49 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Davide Libenzi <davidel@xmailserver.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 2/6] epoll keyed wakeups v2 - introduce new *_poll()
 wakeup macros
In-Reply-To: <alpine.DEB.1.10.0902031231110.23050@alien.or.mcafeemobile.com>
Message-ID: <alpine.LFD.2.00.0902031253120.3247@localhost.localdomain>
References: <send-serie.davidel@xmailserver.org.13601.1233518664.2> <20090203001401.cc960d4e.akpm@linux-foundation.org> <alpine.DEB.1.10.0902031011380.23050@alien.or.mcafeemobile.com> <alpine.DEB.1.10.0902031116500.23050@alien.or.mcafeemobile.com>
 <20090203121041.23d440be.akpm@linux-foundation.org> <alpine.LFD.2.00.0902031219520.3247@localhost.localdomain> <alpine.DEB.1.10.0902031231110.23050@alien.or.mcafeemobile.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Feb 2009, Davide Libenzi wrote:
> 
> There's another thing. Epoll is the *only* user of such thing. I could 
> suck it in there if you prefer. wake_up_nested(), once 
> wake_up_nested_poll() goes in, has no more users and IMO can go.

Ahh. Even better. Make it so.

		Linus
