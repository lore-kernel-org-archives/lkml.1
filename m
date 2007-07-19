Return-Path: <linux-kernel-owner+w=401wt.eu-S933577AbXGSVjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933577AbXGSVjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbXGSVjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:39:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37461 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787AbXGSVjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:39:35 -0400
Subject: Re: About get_page for compound page
From: Peter Zijlstra <peterz@infradead.org>
To: Fengwei Yin <yfw.kernel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <ab18d8520707190854v50216497mcc2be291d1a99ab2@mail.gmail.com>
References: <ab18d8520707190854v50216497mcc2be291d1a99ab2@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 19 Jul 2007 23:39:32 +0200
Message-Id: <1184881172.20032.160.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-19 at 23:54 +0800, Fengwei Yin wrote:
> Hi,
> In get_page(), the parameter page is changed by
>          page = compound_head(page);
> if the page is not the first page of compound pages.
> 
> My question: is this behavior correct?

Yes it is, in general the page state of a compound page is kept in the
first page of the set.

