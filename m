Return-Path: <linux-kernel-owner+w=401wt.eu-S1756315AbXFZIzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbXFZIzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 04:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbXFZIzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 04:55:40 -0400
Received: from ihemail1.lucent.com ([135.245.0.33]:64401 "EHLO
	ihemail1.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbXFZIzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 04:55:40 -0400
Message-ID: <4680D48F.6070105@alcatel-lucent.com>
Date: Tue, 26 Jun 2007 16:55:43 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: bugs in __schedule()
References: <4680C6F3.9000504@alcatel-lucent.com>	 <a781481a0706260118o2ef795bj579b3ec86c4fca8a@mail.gmail.com>	 <4680CC51.1050205@alcatel-lucent.com>	 <a781481a0706260125l76c5848aq85403a4ec94d57da@mail.gmail.com>	 <4680D007.3040007@alcatel-lucent.com> <a781481a0706260150q2c27ddcal9595ebe91ff844c2@mail.gmail.com>
In-Reply-To: <a781481a0706260150q2c27ddcal9595ebe91ff844c2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jun 2007 08:55:25.0047 (UTC) FILETIME=[BC692870:01C7B7CF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> On 6/26/07, gshan <gshan@alcatel-lucent.com> wrote:
>> Thanks, Satyam. So I can replace the tasklet with kernel thread?
>
> That depends on what you want to do ...
>
> [ BTW: I should correct a typo in my original reply -- I should've said
> "scheduling while atomic", and not "scheduling while interrupts disabled"
> because interrupts are _not_ disabled in bottom halves, and from your
> stack backtrace it was evident that a tasklet was executing. :-) ]
I mean kernel thread could sleep, but tasklet can't. If so, it meet my 
requirements.
