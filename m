Return-Path: <linux-kernel-owner+w=401wt.eu-S1765658AbXHFU44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765658AbXHFU44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 16:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755774AbXHFU4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 16:56:47 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:47408 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbXHFU4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 16:56:47 -0400
Message-ID: <46B78ADA.2000009@hp.com>
Date: Mon, 06 Aug 2007 16:55:54 -0400
From: Vlad Yasevich <vladislav.yasevich@hp.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>
Cc: lksctp-developers@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Srinivas Akkipeddi <sakkiped@starentnetworks.com>
Subject: Re: [PATCH] SCTP: IPv4 mapped addr not returned in SCTPv6 accept()
References: <18087.57737.908842.337891@zeus.sw.starentnetworks.com>	<46A8E027.10802@hp.com>	<18088.61269.5608.925496@zeus.sw.starentnetworks.com>	<46A8F926.1070606@hp.com> <18103.35100.916194.803006@zeus.sw.starentnetworks.com>
In-Reply-To: <18103.35100.916194.803006@zeus.sw.starentnetworks.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Johnson wrote:
> Vlad Yasevich writes:
>> Ok.  First, this is a different bug, so I would prefer a separate patch.
>> Also, I see the problem and it's ugly, but this solution is not really correct,
>> both conceptually and code wise.
>>
>> Conceptually, the v4 code should never worry about V4-mapped addresses and shouldn't
>> muck with them.  They are IPv6 addresses and there should be a clean separation.
>>
>> Code wise, the code in the __sctp_connect() is terrible.
>>
>> Does the attached patch work for you in this case.
> 
> Sorry about the confusion before, your patch to __sctp_connect()
> fixes calls to getpeername() after connect() just fine.
> 
> I'll post a patch for the accept()/getpeername() case in a bit.
> 
> Acked-by: Dave Johnson <djohnson@sw.starentnetworks.com>
> 

I had time to tinker and pushed both patches already.  They were in
the last pull that Dave Miller did.  I also tested both patches locally
to make sure that they worked as supposed to.

-vlad
