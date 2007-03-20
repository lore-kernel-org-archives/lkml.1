Return-Path: <linux-kernel-owner+w=401wt.eu-S1753730AbXCTMNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbXCTMNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 08:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbXCTMNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 08:13:39 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:38360 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbXCTMNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 08:13:38 -0400
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20070319195442.GT4892@waste.org>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
	 <20070318162720.GI10459@waste.org> <1174236579.17249.6.camel@sauron>
	 <20070318191812.GM4892@waste.org>
	 <20070318203149.GC29295@crusty.rchland.ibm.com>
	 <20070319170838.GP4892@waste.org>
	 <1174328188.30079.46.camel@zod.rchland.ibm.com>
	 <20070319195442.GT4892@waste.org>
Content-Type: text/plain
Date: Tue, 20 Mar 2007 07:13:26 -0500
Message-Id: <1174392806.30079.81.camel@zod.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 14:54 -0500, Matt Mackall wrote:
> 
> False starts that get mainlined delay or prevent things getting done
> right. The question is and remains "is UBI the right way to do
> things?" Not "is UBI the easiest way to do things?" or "is UBI
> something people have already adopted?"
> 
> If the right way is instead to extend the block layer and device
> mapper to encompass the quirks of NAND in a sensible fashion, then UBI
> should not go in.

This is where we disagree obviously.  However, getting UBI into mainline
won't delay or prevent your proposal from getting done.  That's like
saying having ext3 in mainline prevents other filesystems from getting
created.  There is nothing wrong with having different subsystems that
overlap in a few areas.

What you're proposing seems like it would take at least several weeks to
even get close to what is needed in terms of reliability and the
required wear-leveling if it is indeed possible to implement.  And it
would likely duplicate some of the wear-leveling and bad block handling
code that is present in UBI anyway.  In the meantime, the need for UBI
exists today and there is a working, tested implementation available.

josh

