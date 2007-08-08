Return-Path: <linux-kernel-owner+w=401wt.eu-S1757497AbXHHEur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbXHHEur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 00:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXHHEui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 00:50:38 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:62949 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbXHHEuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 00:50:37 -0400
Message-ID: <46B94B94.6000600@nortel.com>
Date: Tue, 07 Aug 2007 22:50:28 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: Zan Lynx <zlynx@acm.org>, Jerry Jiang <wjiang@resilience.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why are some atomic_t's not volatile, while most are?
References: <Pine.LNX.4.64.0707010847370.22564@localhost.localdomain> <20070806123551.a6c3c154.wjiang@resilience.com> <46B72C58.5030502@redhat.com> <46B894E4.4010501@nortel.com> <46B8D6D7.2020206@redhat.com> <46B8DDF3.7050008@nortel.com> <46B8E1D3.8050501@redhat.com>  <46B8E64E.7010708@nortel.com> <1186525977.232321.43.camel@localhost> <46B91D0C.5050704@redhat.com>
In-Reply-To: <46B91D0C.5050704@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Aug 2007 04:50:32.0029 (UTC) FILETIME=[A673C8D0:01C7D977]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:

> This is not a problem, since indirect references will cause the CPU to 
> fetch the data from memory/cache anyway.

Isn't Zan's sample code (that shows the problem) already using indirect 
references?

Chris
