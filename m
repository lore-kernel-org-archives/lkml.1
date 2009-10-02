Return-Path: <linux-kernel-owner+w=401wt.eu-S1753004AbZJBN7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbZJBN7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 09:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbZJBN7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 09:59:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54255 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbZJBN7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 09:59:32 -0400
Date: Fri, 2 Oct 2009 06:58:59 -0700
From: Greg KH <greg@kroah.com>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, dm-devel@redhat.com,
       Evgeniy Polyakov <zbr@ioremap.net>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/8] SECURITY ISSUE with connector
Message-ID: <20091002135859.GA9383@kroah.com>
References: <1254487211-11810-1-git-send-email-philipp.reisner@linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254487211-11810-1-git-send-email-philipp.reisner@linbit.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 02:40:03PM +0200, Philipp Reisner wrote:
> Affected: All code that uses connector, in kernel and out of mainline
> 
> The connector, as it is today, does not allow the in kernel receiving
> parts to do any checks on privileges of a message's sender.

So, assume I know nothing about the connector architecture, what does
this mean in a security context?

> I know, there are not many out there that like connector, but as
> long as it is in the kernel, we have to fix the security issues it has!

And what specifically are the security issues?

> Please either drop connector, or someone who feels a bit responsible
> and has our beloved dictator's blessing, PLEASE PLEASE PLEASE take 
> this into your tree, and send the pull request to Linus.
> 
> Patches 1 to 4 are already Acked-by Evgeny, the connector's maintainer.
> Patches 5 to 7 are the obvious fixes to the connector user's code.

Obvious in what way?

thanks,

greg k-h
