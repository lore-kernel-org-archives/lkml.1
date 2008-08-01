Return-Path: <linux-kernel-owner+w=401wt.eu-S1759131AbYHATQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759131AbYHATQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 15:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757381AbYHATQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 15:16:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757240AbYHATQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 15:16:12 -0400
Date: Fri, 1 Aug 2008 12:15:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Josh Boyer <jwboyer@gmail.com>
cc: Ulrich Teichert <krypton@ulrich-teichert.org>,
       Tim Bird <tim.bird@am.sony.com>, David Miller <davem@davemloft.net>,
       dwmw2@infradead.org, thomas.petazzoni@free-electrons.com,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com
Subject: Re: [patch 0/4] [resend] Add configuration options to disable
 features
In-Reply-To: <1217533588.2328.1.camel@localhost.localdomain>
Message-ID: <alpine.LFD.1.10.0808011212430.3277@nehalem.linux-foundation.org>
References: <200807311850.m6VIoqCE015883@arbas.nms.ulrich-teichert.org> <1217533588.2328.1.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 31 Jul 2008, Josh Boyer wrote:
> On Thu, 2008-07-31 at 20:50 +0200, Ulrich Teichert wrote:
> > 
> > I do not think of NTP as desktop or server application, but that's
> > probably just me,
> 
> No, it's not just you.  NTP is useful in cases where things do care
> about time but hardware designers were too cheap to put an RTC on the
> board.

In fact, didn't one of the netgear firewall/switch/routers end up being 
famous for overloading some NTP service exactly because all the _millions_ 
of routers ended up using the same (incorrect) NTP host?

So NTP is very definitely an embedded thing too.

			Linus
