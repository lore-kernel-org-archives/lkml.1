Return-Path: <linux-kernel-owner+w=401wt.eu-S1762422AbYFLN5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762422AbYFLN5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759050AbYFLN5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:57:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51095 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbYFLN5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:57:11 -0400
Subject: Re: [PATCH 5/5] futex: fix miss ordered wakeups
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1213276932.16459.16.camel@localhost.localdomain>
References: <20080611204916.271608740@mvista.com>
	 <20080611204917.523866467@mvista.com>  <1213250825.31518.80.camel@twins>
	 <1213276932.16459.16.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 15:57:08 +0200
Message-Id: <1213279028.31518.91.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-12 at 06:22 -0700, Daniel Walker wrote:
> On Thu, 2008-06-12 at 08:07 +0200, Peter Zijlstra wrote:
> > On Wed, 2008-06-11 at 13:49 -0700, Daniel Walker wrote:
> > > plain text document attachment (blocked_on-futex.patch)
> > 
> > I thought everybody and his dog didn't care for this?
> 
> Just Thomas ..

And me, I really don't see the point in this, use PI futexes already if
you care for wakeup ordering.

