Return-Path: <linux-kernel-owner+w=401wt.eu-S1757715AbYGIL0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715AbYGIL0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 07:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbYGIL0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 07:26:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752914AbYGIL0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 07:26:09 -0400
Date: Wed, 9 Jul 2008 04:19:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/17] Series to introduce WARN()... a WARN_ON() variant
 that takes printk arguments
Message-Id: <20080709041956.0c52b2d9.akpm@linux-foundation.org>
In-Reply-To: <20080709101348.GA30005@elte.hu>
References: <20080708093800.274504ba@infradead.org>
	<20080709101348.GA30005@elte.hu>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jul 2008 12:13:48 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> > Hi,
> > 
> > This patch series introduces WARN(), which is a WARN_ON() variant that 
> > takes printk() like arguments. This was done after both akpm and I hit 
> > several cases where this would have been useful; in addition, with 
> > WARN(), we put the printk string inside the -----[ cut here ]----- 
> > section, making it more likely that users (and tools like kerneloops) 
> > pick up the message in addition to just the bare WARNING.
> > 
> > The first few patches have been in -mm for a long time; the later ones 
> > are newer and introduce more users of WARN().
> 
> i've created a new -git based topic branch in tip/core/warn-API and 
> picked up your patches:

um, why?

If you merge this into linux-next then it will trash already-merged patches
in -mm and, more particularly, it will trash other trees which you aren't
looking at, causing Stephen problems.

The way to merge this code is to get the base patches into mainline and
then trickle the dependent patches into subsystem trees, or direct into
mainline after the subsystem trees have merged, and with suitable acks.

You aren't set up to do that?
