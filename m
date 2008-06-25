Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbYFYWN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbYFYWN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 18:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbYFYWNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 18:13:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752979AbYFYWNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 18:13:47 -0400
Date: Wed, 25 Jun 2008 15:13:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Lee.Schermerhorn@hp.com,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [-mm][PATCH 10/10] putback_lru_page()/unevictable page handling
 rework v4
Message-Id: <20080625151316.58ed195e.akpm@linux-foundation.org>
In-Reply-To: <20080625191237.D86D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080625185717.D84C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080625191014.D86A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080625191237.D86D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2008 19:14:54 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> putback_lru_page()/unevictable page handling rework.

The other nine patches slotted into the patch series quite nicely. 
This means that those nine patches can later be folded into the patches
which they fixed and everything is nice and logical.

But this patch is not like that - it changes code which was added by
lots of different patches.  This means that if I merge it, this patch
besomes a sort of impermeable barrier which other patches cannot be
reordered across.

And that's kind-of OK.  It's messy, but we could live with it.  However
as I expect there will be more fixes to these patches before all this
work goes into mainline, this particular patch will become more of a
problem as it will make the whole body of work more messy and harder to
review and understand.

So.  Can this patch be simplified in any way?  Or split up into
finer-grained patches or something like that?

Thanks.
