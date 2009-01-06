Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbZAFROb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbZAFROb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 12:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbZAFROW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 12:14:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751566AbZAFROW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 12:14:22 -0500
Date: Tue, 6 Jan 2009 09:13:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: dedekind@infradead.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: mmotm 2009-01-05-12-50 uploaded (ubifs)
Message-Id: <20090106091341.99c59b83.akpm@linux-foundation.org>
In-Reply-To: <1231243904.6608.47.camel@localhost.localdomain>
References: <200901052050.n05Kox9j012519@imap1.linux-foundation.org>
	<49628515.7010609@oracle.com>
	<20090105142437.9406c375.akpm@linux-foundation.org>
	<1231243904.6608.47.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Jan 2009 14:11:44 +0200 Artem Bityutskiy <dedekind@infradead.org> wrote:

> On Mon, 2009-01-05 at 14:24 -0800, Andrew Morton wrote:
> > WB_SYNC_HOLD got removed by
> > http://userweb.kernel.org/~akpm/mmotm/broken-out/fs-remove-wb_sync_hold.patch
> > 
> > I think I'll just switch that to WB_SYNC_NONE.  The `wait==0' mode is
> > just an advisory thing to help the fs shove lots of data into the
> > queues.  If some gets missed then it'll be picked up on the second
> > ->sync_fs call, with wait==1.
> 
> Sorry for the problems caused by this patch. Here is a fix for your
> convenience. Will you send it to Linus or I should do this?
> 
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Subject: [PATCH] UBIFS: do not use WB_SYNC_HOLD

I can take care of that, thanks.
