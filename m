Return-Path: <linux-kernel-owner+w=401wt.eu-S932695AbXHFUs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695AbXHFUs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 16:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758505AbXHFUsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 16:48:51 -0400
Received: from [12.38.223.190] ([12.38.223.190]:5674 "EHLO
	mail.sw.starentnetworks.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758879AbXHFUsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 16:48:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18103.35100.916194.803006@zeus.sw.starentnetworks.com>
Date: Mon, 6 Aug 2007 16:48:28 -0400
From: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: lksctp-developers@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Srinivas Akkipeddi <sakkiped@starentnetworks.com>
Subject: Re: [PATCH] SCTP: IPv4 mapped addr not returned in SCTPv6 accept()
In-Reply-To: <46A8F926.1070606@hp.com>
References: <18087.57737.908842.337891@zeus.sw.starentnetworks.com>
	<46A8E027.10802@hp.com>
	<18088.61269.5608.925496@zeus.sw.starentnetworks.com>
	<46A8F926.1070606@hp.com>
X-Mailer: VM 7.17 under 21.4 (patch 17) "Jumbo Shrimp" XEmacs Lucid
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vlad Yasevich writes:
> Ok.  First, this is a different bug, so I would prefer a separate patch.
> Also, I see the problem and it's ugly, but this solution is not really correct,
> both conceptually and code wise.
> 
> Conceptually, the v4 code should never worry about V4-mapped addresses and shouldn't
> muck with them.  They are IPv6 addresses and there should be a clean separation.
> 
> Code wise, the code in the __sctp_connect() is terrible.
> 
> Does the attached patch work for you in this case.

Sorry about the confusion before, your patch to __sctp_connect()
fixes calls to getpeername() after connect() just fine.

I'll post a patch for the accept()/getpeername() case in a bit.

Acked-by: Dave Johnson <djohnson@sw.starentnetworks.com>

-- 
Dave Johnson
Starent Networks

