Return-Path: <linux-kernel-owner+w=401wt.eu-S1756284AbXFZJNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbXFZJNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 05:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbXFZJNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 05:13:17 -0400
Received: from ihemail1.lucent.com ([135.245.0.33]:51300 "EHLO
	ihemail1.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbXFZJNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 05:13:16 -0400
Message-ID: <4680D8B4.3080001@alcatel-lucent.com>
Date: Tue, 26 Jun 2007 17:13:24 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: bugs in __schedule()
References: <4680C6F3.9000504@alcatel-lucent.com>	 <a781481a0706260118o2ef795bj579b3ec86c4fca8a@mail.gmail.com>	 <4680CC51.1050205@alcatel-lucent.com>	 <a781481a0706260125l76c5848aq85403a4ec94d57da@mail.gmail.com>	 <4680D007.3040007@alcatel-lucent.com>	 <a781481a0706260150q2c27ddcal9595ebe91ff844c2@mail.gmail.com>	 <4680D48F.6070105@alcatel-lucent.com> <a781481a0706260208x678e5e11rdbd163e0e791c3de@mail.gmail.com>
In-Reply-To: <a781481a0706260208x678e5e11rdbd163e0e791c3de@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jun 2007 09:13:06.0047 (UTC) FILETIME=[34D0E8F0:01C7B7D2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> On 6/26/07, gshan <gshan@alcatel-lucent.com> wrote:
>> I mean kernel thread could sleep, but tasklet can't. If so, it meet my
>> requirements.
>
> That's not really a justification to convert a tasklet to a kernel 
> thread.
> I suspect the simplest solution to your problem would be to simply
> replace that semaphore with a spinlock. Other than that, we can't really
> help without looking at code.
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
Thank you very much, Satyam. Anyway, I will do experiments. Thank you 
again :-)

