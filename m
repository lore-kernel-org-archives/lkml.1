Return-Path: <linux-kernel-owner+w=401wt.eu-S1760228AbXFESPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760228AbXFESPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 14:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755307AbXFESPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 14:15:14 -0400
Received: from colin.muc.de ([193.149.48.1]:2450 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085AbXFESPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 14:15:13 -0400
Date: 5 Jun 2007 20:15:10 +0200
Date: Tue, 5 Jun 2007 20:15:10 +0200
From: Andi Kleen <ak@muc.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] lguest tsc fix
Message-ID: <20070605181510.GA7782@muc.de>
References: <1181055308.14054.36.camel@localhost.localdomain> <1181055396.14054.38.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181055396.14054.38.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 12:56:36AM +1000, Rusty Russell wrote:
> In recent -mm kernels, the TSC capability cannot be disabled,
> resulting in a divide by zero error in the normal sched_clock.

That will hopefully change. I hope hpa will just undo this.

> 
> The correct fix is to have a special lguest sched_clock
> implementation: this is as simple as it gets.

But gettimeofday might still use it. Is that ok for you?

-Andi
