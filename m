Return-Path: <linux-kernel-owner+w=401wt.eu-S1763638AbXJEPto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763638AbXJEPto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 11:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756576AbXJEPtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 11:49:36 -0400
Received: from hpsmtp-eml20.kpnxchange.com ([213.75.38.85]:19702 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757929AbXJEPtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 11:49:36 -0400
From: Frans Pop <elendil@planet.nl>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH for testing] Re: Decreasing stime running confuses top
Date: Fri, 5 Oct 2007 17:49:32 +0200
User-Agent: KMail/1.9.7
Cc: Chuck Ebbert <cebbert@redhat.com>, Luca Tettamanti <kronos.it@gmail.com>,
       Willy Tarreau <w@1wt.eu>, LKML <linux-kernel@vger.kernel.org>,
       Ilpo =?iso-8859-1?q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       "Alexander E. Patrakov" <patrakov@ums.usu.ru>,
       Ingo Molnar <mingo@elte.hu>
References: <200710031433.34504.elendil@planet.nl> <47054B2E.1050906@redhat.com> <200710042310.25223.borntraeger@de.ibm.com>
In-Reply-To: <200710042310.25223.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710051749.33381.elendil@planet.nl>
X-OriginalArrivalTime: 05 Oct 2007 15:49:33.0677 (UTC) FILETIME=[5311F1D0:01C80767]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 October 2007, you wrote:
> Frans can you test this patch if this makes stime and utime monotic
> again?
>
> It basically reverts the rest of 
> b27f03d4bdc145a09fb7b0c0e004b29f1ee555fa and should restore the 2.6.22
> behavior. The process time is used from tasks utime and stime instead of
> the scheduler clock. That means, in general after a long period of time,
> it is less accurate than the current time and behaves like 2.6.22.
>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

Yes, this gives steady increases.
For kontact it also again shows updates only once every minute. I really 
wonder where all the other fluctuations for contact come from with the 
alternative code.

It seems to me that this patch would be the best option for 2.6.23.

Tested-by: Frans Pop <elendil@planet.nl>
