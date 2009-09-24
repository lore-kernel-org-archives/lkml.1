Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbZIXSLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbZIXSLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 14:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbZIXSLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 14:11:18 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:51863 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752970AbZIXSLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 14:11:17 -0400
From: Frans Pop <elendil@planet.nl>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: disk speed regression kernel 2.6.29 and after
Date: Thu, 24 Sep 2009 20:11:18 +0200
User-Agent: KMail/1.9.9
Cc: whansard@sbcglobal.net, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, David Miller <davem@davemloft.net>
References: <4ABA0FDA.9090707@sbcglobal.net> <200909241426.49947.bzolnier@gmail.com> <20090924112645.dc97dd07.whansard@sbcglobal.net> <20090924112645.dc97dd07.whansard@sbcglobal.net> <200909241934.27472.bzolnier@gmail.com>
In-reply-To: <200909241934.27472.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909242011.20032.elendil@planet.nl>
X-OriginalArrivalTime: 24 Sep 2009 18:11:20.0421 (UTC) FILETIME=[6AE81150:01CA3D42]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> Regarding additional pursue of the root cause, I think that it is not
> worth the effort currently since there were no other reports about
> similar problems and libata is a better solution on most modern systems
> anyway. 

I'm surprised at this, especially if the commit Will bisected it to [1] is 
the culprit. That is a change in generic ide code and could thus very well 
affect other users too.

This is a clear regression and IMHO, if it is confirmed that that commit is 
the cause of the regression, it should be fixed. And if not, it could 
still be worthwhile to track down which commit is the cause.

As for the lack of other reports, that could very well simply be because:
1) there are not that many users of IDE drivers anymore
2) most users don't really consciously watch their disk speed

As long as the IDE code is in mainline, I don't see why regressions should 
be ignored. Adding the ide list and David to CC for other opinions.

Cheers,
FJP

[1] http://lkml.org/lkml/2009/9/23/550
