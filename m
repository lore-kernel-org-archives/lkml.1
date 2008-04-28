Return-Path: <linux-kernel-owner+w=401wt.eu-S1763228AbYD1AcC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763228AbYD1AcC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 20:32:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbYD1Ab4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 20:31:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbYD1Abz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 20:31:55 -0400
Date: Sun, 27 Apr 2008 20:31:27 -0400
From: Rik van Riel <riel@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, James.Bottomley@HansenPartnership.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
Message-ID: <20080427203127.3c7d0e58@bree.surriel.com>
In-Reply-To: <20080427.163106.181887129.davem@davemloft.net>
References: <20080427214837.GA11631@elte.hu>
	<1209333959.3801.67.camel@localhost.localdomain>
	<20080427231809.GA13848@elte.hu>
	<20080427.163106.181887129.davem@davemloft.net>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Apr 2008 16:31:06 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> You can post whatever patches you like a million times to lkml.
> That's not the problem.
> 
> It's that the patches don't get reviewed, posting them more or to a
> different place doesn't help that.

If you really want to enforce this, I bet it could be automated
with scripts around git.

Simply refuse to apply a patch that does not have at least two
Signed-off-by/Reviewed-by/Acked-by lines and refuse to apply
a "git pull" if there is a changeset like that in the tree.

Of course, this could end up screwing rare architectures like
Voyager, so I'm not convinced it is a good idea...

-- 
All rights reversed.
