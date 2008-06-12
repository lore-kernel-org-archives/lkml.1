Return-Path: <linux-kernel-owner+w=401wt.eu-S1762128AbYFLNWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762128AbYFLNWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760171AbYFLNWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:22:14 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:59613 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775AbYFLNWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:22:14 -0400
Subject: Re: [PATCH 5/5] futex: fix miss ordered wakeups
From: Daniel Walker <dwalker@mvista.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1213250825.31518.80.camel@twins>
References: <20080611204916.271608740@mvista.com>
	 <20080611204917.523866467@mvista.com>  <1213250825.31518.80.camel@twins>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 06:22:12 -0700
Message-Id: <1213276932.16459.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-12 at 08:07 +0200, Peter Zijlstra wrote:
> On Wed, 2008-06-11 at 13:49 -0700, Daniel Walker wrote:
> > plain text document attachment (blocked_on-futex.patch)
> 
> I thought everybody and his dog didn't care for this?

Just Thomas ..


> Also, if you write it like:
> 
>   if (!p->blocked_on)
>     return
> 
>   do_other_stuff
> 
> you loose one nesting level - which imho looks better.

Yeah ..

Daniel

