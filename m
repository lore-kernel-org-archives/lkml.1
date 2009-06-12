Return-Path: <linux-kernel-owner+w=401wt.eu-S1758849AbZFLIJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849AbZFLIJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbZFLIJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:09:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53946 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019AbZFLIJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:09:16 -0400
Date: Fri, 12 Jun 2009 10:02:12 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] posix-cpu-timers: remove tasklist_lock where we can
Message-ID: <20090612100212.06f56a79@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <4A320848.6000701@rsk.demon.co.uk>
References: <20090612084927.11673956@dhcp-lab-109.englab.brq.redhat.com>
	<4A320848.6000701@rsk.demon.co.uk>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009 08:48:24 +0100
Richard Kennedy <richard@rsk.demon.co.uk> wrote:

> > -	read_unlock(&tasklist_lock);
> > +	rcu_read_lock();
> >  
> Did you really intend to replace an unlock with a lock?

Intention was quite different. 

Thanks
Stanislaw 
