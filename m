Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbZEZHAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbZEZHAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 03:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbZEZHAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 03:00:14 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:57168 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbZEZHAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 03:00:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=KmcBrpYyB6lEWmUZ2fUhiMzKYLmh8PTGj0mj3log9gCHOm07O94ZG3pPgtDttEaaX4
         fSk/Hj7NOcRn5ctxoGfmgx3lkwdjnlGXjZz35nl0PTL5yOD1Z12l7yENzmv0RMIT1BSL
         vgNLVpYSDu3iFGwtCi17b7zukAKuZI7OclDII=
Date: Tue, 26 May 2009 15:59:43 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, akpm@linux-foundation.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
       Pavel Machek <pavel@ucw.cz>, Dave Hansen <dave@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][mmtom] clean up once printk routine
Message-Id: <20090526155943.aef3ba62.minchan.kim@barrios-desktop>
In-Reply-To: <20090526155155.6871.A69D9226@jp.fujitsu.com>
References: <20090526135733.3c38f758.minchan.kim@barrios-desktop>
	<20090526155155.6871.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009 15:52:32 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > == CUT HERE ==
> > 
> > There are some places to be able to use printk_once instead of hard coding.
> > 
> > It will help code readability and maintenance.
> > This patch doesn't change function's behavior.
> > 
> > Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> > CC: Dominik Brodowski <linux@dominikbrodowski.net>
> > CC: David S. Miller <davem@davemloft.net>
> > CC: Ingo Molnar <mingo@elte.hu>
> > ---
> >  arch/x86/kernel/cpu/common.c  |    8 ++------
> >  drivers/net/3c515.c           |    7 ++-----
> >  drivers/pcmcia/pcmcia_ioctl.c |    9 +++------
> >  3 files changed, 7 insertions(+), 17 deletions(-)
> 
> Please separete to three patches ;)

After I listen about things I missed, I will repost it at all once with each patch.
Thanks for comment. Kosaki. :)


-- 
Kinds Regards
Minchan Kim
