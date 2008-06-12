Return-Path: <linux-kernel-owner+w=401wt.eu-S1761199AbYFLOFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761199AbYFLOFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 10:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760258AbYFLOE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 10:04:59 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:2273 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760248AbYFLOE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 10:04:58 -0400
Subject: Re: [PATCH 5/5] futex: fix miss ordered wakeups
From: Daniel Walker <dwalker@mvista.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1213279028.31518.91.camel@twins>
References: <20080611204916.271608740@mvista.com>
	 <20080611204917.523866467@mvista.com>  <1213250825.31518.80.camel@twins>
	 <1213276932.16459.16.camel@localhost.localdomain>
	 <1213279028.31518.91.camel@twins>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 07:04:55 -0700
Message-Id: <1213279495.16459.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-12 at 15:57 +0200, Peter Zijlstra wrote:
> On Thu, 2008-06-12 at 06:22 -0700, Daniel Walker wrote:
> > On Thu, 2008-06-12 at 08:07 +0200, Peter Zijlstra wrote:
> > > On Wed, 2008-06-11 at 13:49 -0700, Daniel Walker wrote:
> > > > plain text document attachment (blocked_on-futex.patch)
> > > 
> > > I thought everybody and his dog didn't care for this?
> > 
> > Just Thomas ..
> 
> And me, I really don't see the point in this, use PI futexes already if
> you care for wakeup ordering.

Does it make sense that we allow a priority based plist ordering, but we
don't keep the priorities up to date? That doesn't make sense to me.

Daniel

