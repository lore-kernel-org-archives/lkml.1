Return-Path: <linux-kernel-owner+w=401wt.eu-S1761916AbYEWFPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761916AbYEWFPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 01:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbYEWFPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 01:15:24 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:43857 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbYEWFPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 01:15:24 -0400
Subject: Re: [PATCH 3/3] futex: fix miss ordered wakeups
From: Daniel Walker <dwalker@mvista.com>
To: Ulrich Drepper <drepper@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <a36005b50805222202v6ea7b50p988eab5524935e1a@mail.gmail.com>
References: <20080523042923.594531457@mvista.com>
	 <20080523042923.916202203@mvista.com>
	 <a36005b50805222202v6ea7b50p988eab5524935e1a@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 22 May 2008 22:15:19 -0700
Message-Id: <1211519720.18130.98.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-22 at 22:02 -0700, Ulrich Drepper wrote:
> On Thu, May 22, 2008 at 12:00 AM, Daniel Walker <dwalker@mvista.com> wrote:
> > This patch corrects this issue, so the tasks are always woken in priority
> > order.
> 
> This is completely unnecessary overhead for 99.999% of all cases.  It
> was deliberately not done.  You slowing things down for everybody.  If
> you want priorities, then use PI futexes.

That's the problem we aren't just covering 99.99% we're trying to cover
100% of cases.. If we don't do it in that one case we may as well not do
it at all.

Daniel

