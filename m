Return-Path: <linux-kernel-owner+w=401wt.eu-S934336AbXHGPvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934336AbXHGPvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 11:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761617AbXHGPvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 11:51:10 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:40268 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864AbXHGPvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 11:51:09 -0400
Message-ID: <46B894E4.4010501@nortel.com>
Date: Tue, 07 Aug 2007 09:51:00 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: Jerry Jiang <wjiang@resilience.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why are some atomic_t's not volatile, while most are?
References: <Pine.LNX.4.64.0707010847370.22564@localhost.localdomain> <20070806123551.a6c3c154.wjiang@resilience.com> <46B72C58.5030502@redhat.com>
In-Reply-To: <46B72C58.5030502@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Aug 2007 15:51:03.0410 (UTC) FILETIME=[C22EDD20:01C7D90A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:

> If your architecture doesn't support SMP, the volatile keyword doesn't 
> do anything except add a useless memory fetch.

I was under the impression that there were other cases as well 
(interrupt handlers, for instance) where the value could be modified 
"behind the back" of the current code.

It seems like this would fall more into the case of the arch providing 
guarantees when using locked/atomic access rather than anything 
SMP-related, no?.

Chris
