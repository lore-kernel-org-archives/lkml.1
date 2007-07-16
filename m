Return-Path: <linux-kernel-owner+w=401wt.eu-S1763672AbXGPAce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763672AbXGPAce (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 20:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758666AbXGPAc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 20:32:27 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:36638 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757975AbXGPAc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 20:32:26 -0400
Date: Sun, 15 Jul 2007 17:35:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Flavio Curti <lists.fcu@no-way.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: panics with 16port Promise Supertrack EX Controller
Message-Id: <20070715173515.49883f4a.randy.dunlap@oracle.com>
In-Reply-To: <20070715225155.GD21260@no-way.org>
References: <20070708225246.GD16285@no-way.org>
	<6bffcb0e0707081620pf4afd46re9e74e18518b352a@mail.gmail.com>
	<46919688.1050005@yahoo.com.au>
	<20070715225155.GD21260@no-way.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007 00:51:55 +0200 Flavio Curti wrote:

> Hello
> 
> On Mon, Jul 09, 2007 at 11:59:36AM +1000, Nick Piggin wrote:
> > >Jul  8 00:19:13 dorade.cyberlink.ch EFLAGS: 00210046   
> > >(2.6.22-rc7-dorade #1)
> > >>The machine panics
> > >>after some days of running fine, the machine inst heavy loaded.
> > >>The Controller detects as stex device:
> > >kernel BUG at block/as-iosched.c:1084!
> > >
> > >BUG_ON(RB_EMPTY_ROOT(&ad->sort_list[REQ_ASYNC]));
> > Could be a bug in the driver that just happens to be caught by AS checks.
> > If you could test another scheduler (boot with elevator=deadline or 
> > elevator=cfq),
> > it might help give us an idea.
> 
> Ok, I now switched to cfg, and the machine panicd again. Panic attached.
> Any help is appreciated.

Make sure that you switched to "cfq" and not "cfg".

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
