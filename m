Return-Path: <linux-kernel-owner+w=401wt.eu-S933536AbZFQMhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933536AbZFQMhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 08:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933276AbZFQMh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 08:37:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60384 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756422AbZFQMh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 08:37:26 -0400
Date: Wed, 17 Jun 2009 13:37:22 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Snitzer <snitzer@redhat.com>
Subject: Re: linux-next: device-mapper tree build warnings
Message-ID: <20090617123722.GD8912@agk-dp.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
References: <20090617130806.c17ec577.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090617130806.c17ec577.sfr@canb.auug.org.au>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 01:08:06PM +1000, Stephen Rothwell wrote:
> Today's linux-next build (x86_64 allmodconfig) produced these warnings:
> drivers/md/dm-delay.c: In function 'delay_iterate_devices':
> drivers/md/dm-delay.c:327: warning: passing argument 1 of 'fn' from incompatible pointer type
> drivers/md/dm-delay.c:327: note: expected 'struct dm_target *' but argument is of type 'struct delay_c *'
> drivers/md/dm-delay.c:332: warning: passing argument 1 of 'fn' from incompatible pointer type
> drivers/md/dm-delay.c:332: note: expected 'struct dm_target *' but argument is of type 'struct delay_c *'
> Introduced by commit ac2152571c038de73be920db171fb438d32bb744
> ("dm-targets-introduce-iterate-devices-fn").

Resolved, thanks.

Alasdair

