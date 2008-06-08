Return-Path: <linux-kernel-owner+w=401wt.eu-S1757236AbYFHQHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbYFHQHc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 12:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbYFHQHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 12:07:20 -0400
Received: from 1wt.eu ([62.212.114.60]:1615 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762AbYFHQHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 12:07:19 -0400
Date: Sun, 8 Jun 2008 18:06:56 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jay Cliburn <jacliburn@bellsouth.net>
Cc: David Miller <davem@davemloft.net>, pupilla@hotmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       chrisw@sous-sol.org, jeff@garzik.org
Subject: Re: [patch 00/50] 2.6.25.6 -stable review
Message-ID: <20080608160656.GL5609@1wt.eu>
References: <20080607204325.GJ5609@1wt.eu> <BAY103-DAV7370611E1B3FEA8FD69B9B2B10@phx.gbl> <20080608123601.GB10491@1wt.eu> <20080608.071051.212882594.davem@davemloft.net> <20080608103835.0c0b1e83@osprey.hogchain.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080608103835.0c0b1e83@osprey.hogchain.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2008 at 10:38:35AM -0500, Jay Cliburn wrote:
> On Sun, 08 Jun 2008 07:10:51 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
> 
> 
> > If you ask me in the future about the status of a -stable
> > patch from the networking, I'll let you know exactly what
> > is happening to that patch wrt. stable.  I rarely forget
> > to submit an appropriate patch, and when I do forget you
> > merely have to let me know (rather than submitting it
> > to -stable directly, please don't do that) so that I can
> > fit it in with what I plan to submit to -stable already.
> 
> 
> As a netdev driver maintainer, I've been following this workflow for
> patches that need to go to -stable:
> 
> 1.  I submit a mainline patch to Jeff Garzik.
> 2.  Jeff submits to David.
> 3.  David submits to Linus.
> 4.  Linus merges patch into mainline.
> 5.  I extract mainline commit ID.
> 6.  I apply and test patch against appropriate 2.6.x.y git tree.
> 7.  I submit patch directly to -stable.
> 
> David's admonition tells me I'm doing it wrong, and that I should
> submit the stable patch to Jeff as well.  Am I right?

The normal recommended method to get patches automatically sent to
stable is to add a "Cc: stable@kernel.org" line above your signed-off-by
line. That way it is automatically sent to stable when Linus merges it,
and David gets notified. This should *theorically* save him some of the
work consisting in checking his stable queue for unmerged patches, but
his workflow may be different. Also, this method is particularly suited
to ensure that patches don't get lost when the maintainer does not have
a specific stable queue, which is not the case here, according to David.

Regards,
Willy

