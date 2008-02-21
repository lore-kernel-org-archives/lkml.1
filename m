Return-Path: <linux-kernel-owner+w=401wt.eu-S932880AbYBUNj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880AbYBUNj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 08:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYBUNjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 08:39:51 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:52227 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbYBUNju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 08:39:50 -0500
Subject: Re: [LTP] [PATCH 1/8] Scaling msgmni to the amount of lowmem
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Matt Helsley <matthltc@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       ltp-list@lists.sourceforge.net, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, cmm@us.ibm.com,
       y-goto@jp.fujitsu.com
In-Reply-To: <47BD7648.5010309@bull.net>
References: <20080211141646.948191000@bull.net>
	 <20080211141813.354484000@bull.net>
	 <20080215215916.8566d337.akpm@linux-foundation.org>
	 <47B94D8C.8040605@bull.net>  <47B9835A.3060507@bull.net>
	 <1203411055.4612.5.camel@subratamodak.linux.ibm.com>
	 <47BB0EDC.5000002@bull.net>
	 <1203459418.7408.39.camel@localhost.localdomain>
	 <47BD705A.9020309@bull.net>  <47BD7648.5010309@bull.net>
Content-Type: text/plain
Organization: IBM
Date: Thu, 21 Feb 2008 19:09:38 +0530
Message-Id: <1203601178.4604.18.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Nadia Derbey wrote:
> > Matt Helsley wrote:
> > 
> >> On Tue, 2008-02-19 at 18:16 +0100, Nadia Derbey wrote:
> >>
> >> <snip>
> >>
> >>> +#define MAX_MSGQUEUES  16      /* MSGMNI as defined in linux/msg.h */
> >>> +
> >>
> >>
> >>
> >> It's not quite the maximum anymore, is it? More like the minumum
> >> maximum ;). A better name might better document what the test is
> >> actually trying to do.
> >>
> >> One question I have is whether the unpatched test is still valuable.
> >> Based on my limited knowledge of the test I suspect it's still a correct
> >> test of message queues. If so, perhaps renaming the old test (so it's
> >> not confused with a performance regression) and adding your patched
> >> version is best?
> >>
> > 
> > So, here's the new patch based on Matt's points.
> > 
> > Subrata, it has to be applied on top of the original ltp-full-20080131. 
> > Please tell me if you'd prefer one based on the merged version you've 
> > got (i.e. with my Tuesday patch applied).

Nadia, I would prefer Patch on the top of the already merged version (on
top of latest CVS snapshot as of today). Anyways, thanks for all these
effort :-)

--Subrata

> > 
> 
> Forgot the patch, sorry for that (thx Andrew).
> 
> Regards,
> Nadia
> 

