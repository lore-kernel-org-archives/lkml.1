Return-Path: <linux-kernel-owner+w=401wt.eu-S1757408AbZA0TAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbZA0TAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 14:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbZA0TA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 14:00:29 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:54840 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbZA0TA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 14:00:28 -0500
X-Greylist: delayed 1839 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jan 2009 14:00:28 EST
Message-ID: <497F5289.404@nortel.com>
Date: Tue, 27 Jan 2009 12:29:29 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: marching through all physical memory in software
References: <497DD8E5.1040305@nortel.com> <20090126075957.69b64a2e@infradead.org>
In-Reply-To: <20090126075957.69b64a2e@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jan 2009 18:29:30.0427 (UTC) FILETIME=[3175C8B0:01C980AD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Mon, 26 Jan 2009 09:38:13 -0600
> "Chris Friesen" <cfriesen@nortel.com> wrote:
> 
>> Someone is asking me about the feasability of "scrubbing" system
>> memory by accessing each page and handling the ECC faults.
>>
> 
> Hi,
> 
> I would suggest that you look at the "edac" subsystem, which tries to
> do exactly this....

Looking at the current -git code, there appears to be an option for 
memory controllers to do this (the set_sdram_scrub_rate() routine), but 
there don't appear to be any controllers that can actually do it.

edac appears to currently be able to scrub the specific page where the 
fault occurred.  This is a useful building block, but doesn't provide 
the ability to march through all of physical memory.

Chris

