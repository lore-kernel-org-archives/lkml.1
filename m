Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbZJLLX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbZJLLX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 07:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410AbZJLLX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 07:23:56 -0400
Received: from ernst.netinsight.se ([194.16.221.21]:65404 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752316AbZJLLXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 07:23:55 -0400
Date: Mon, 12 Oct 2009 13:23:04 +0200
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Aaro Koskinen <aaro.koskinen@nokia.com>,
       David Woodhouse <dwmw2@infradead.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] panic.c: export panic_on_oops
Message-ID: <20091012132304.52d4646c@marrow.netinsight.se>
In-Reply-To: <20091012111545.GB8857@elte.hu>
References: <1255241458-11665-1-git-send-email-dedekind1@gmail.com>
	<20091012111545.GB8857@elte.hu>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 13:15:45 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> * Artem Bityutskiy <dedekind1@gmail.com> wrote:
>
> > We use the mtdoops module which stores oopses on the Flash partition,
> > in order to make it possible to analyze them later. And mtdoops needs
> > to know whether 'panic_on_oops' is on or off. Thus, we need this
> > variable to be exported.
> 
> hm, why does it need it? Could you send the patch please that makes use 
> of it (as an easy way to explain the need for the export) - current 
> upstream drivers/mtd/mtdoops.c doesnt need it so it must be some pending 
> change.

You have the patch that requires it here:

  http://patchwork.ozlabs.org/patch/34732/

it's a fix to allow mtdoops to actually store oopses which happen when
panic_on_oops is set (before these would be missed as the write would
never be done).

// Simon

