Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbXEQJfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbXEQJfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 05:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbXEQJf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 05:35:26 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:48505 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbXEQJfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 05:35:25 -0400
Date: Thu, 17 May 2007 10:35:23 +0100 (IST)
From: Mel Gorman <mel@csn.ul.ie>
X-X-Sender: mel@skynet.skynet.ie
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steve Fox <drfickle@us.ibm.com>
Subject: Re: 2.6.22-rc1-mm1
In-Reply-To: <464B9573.8030407@zytor.com>
Message-ID: <Pine.LNX.4.64.0705171013560.27336@skynet.skynet.ie>
References: <20070515201914.16944e04.akpm@linux-foundation.org>
 <464ADA5D.8050405@shadowen.org> <464B2048.7040103@zytor.com>
 <20070516174046.GE10225@skynet.ie> <464B9573.8030407@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007, H. Peter Anvin wrote:

> Correction, does *this patch* do it for you?
>

With these two patches in combination, previously failing machines elm3b6 
(x86_64 on test.kernel.org) and a modern x86 built a kernel and booted 
correctly.

elm3b132 and elm3b132 (x86 numaq on test.kernel.org) built with these 
patches but silently fail on boot with no output via earlyprintk. 
According to test.kernel.org, this failure occurs with git-newsetup 
reverted so it is a separate problem.

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
