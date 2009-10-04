Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbZJDKZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbZJDKZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 06:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbZJDKZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 06:25:28 -0400
Received: from cs-studio.ru ([195.178.208.66]:37979 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbZJDKZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 06:25:27 -0400
Date: Sun, 4 Oct 2009 14:24:50 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, Greg KH <greg@kroah.com>,
       dm-devel@redhat.com, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/8] SECURITY ISSUE with connector
Message-ID: <20091004102450.GB2569@ioremap.net>
References: <1254487211-11810-1-git-send-email-philipp.reisner@linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254487211-11810-1-git-send-email-philipp.reisner@linbit.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 02:40:03PM +0200, Philipp Reisner (philipp.reisner@linbit.com) wrote:
> Affected: All code that uses connector, in kernel and out of mainline
> 
> The connector, as it is today, does not allow the in kernel receiving
> parts to do any checks on privileges of a message's sender.
> 
> I know, there are not many out there that like connector, but as
> long as it is in the kernel, we have to fix the security issues it has!
> 
> Please either drop connector, or someone who feels a bit responsible
> and has our beloved dictator's blessing, PLEASE PLEASE PLEASE take 
> this into your tree, and send the pull request to Linus.

How expressive! :)

> Patches 1 to 4 are already Acked-by Evgeny, the connector's maintainer.
> Patches 5 to 7 are the obvious fixes to the connector user's code.

I ack those changes either since they do not affect logic of the user.

-- 
	Evgeniy Polyakov
