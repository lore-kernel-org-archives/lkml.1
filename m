Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbZIVNiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbZIVNiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZIVNiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:38:12 -0400
Received: from gir.skynet.ie ([193.1.99.77]:50145 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327AbZIVNiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:38:11 -0400
Date: Tue, 22 Sep 2009 14:38:17 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: ???? <win847@gmail.com>
Cc: Sachin Sant <sachinp@in.ibm.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Tejun Heo <tj@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC PATCH 0/3] Fix SLQB on memoryless configurations V2
Message-ID: <20090922133817.GE25965@csn.ul.ie>
References: <1253549426-917-1-git-send-email-mel@csn.ul.ie> <20090921174656.GS12726@csn.ul.ie> <alpine.DEB.1.10.0909211349530.3106@V090114053VZO-1> <20090921180739.GT12726@csn.ul.ie> <4AB85A8F.6010106@in.ibm.com> <20090922125546.GA25965@csn.ul.ie> <4AB8CB81.4080309@in.ibm.com> <20090922132018.GB25965@csn.ul.ie> <363172900909220629j2f5174cbo9fe027354948d37@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <363172900909220629j2f5174cbo9fe027354948d37@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 09:29:44PM +0800, ???? wrote:
> Dear all,
>        I want ask question about kernel-customization. Our product is
> embedded system, such as ADSL Modem(home gateway).  and we use linux
> 2.6.22.15 version. Now config for linux kernel will build kernel size is
> 800KB. How can I config kernel config to reduce kernel size, I want to get
> smaller size  like 500KB.
> But out product is network device,so some network protocol of kernel can not
> remove. Below is our config, all of you can give me suggestion, Thanks very
> much!
> 

*blinks*

This is not a sensible thread to ask the question on.

I haven't looked at your config to see how it might be stripped down but
I would suggest using scripts/bloat-o-meter to start getting a breakdown
per-subsystem that is making up the bulk of your kernel image.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
