Return-Path: <linux-kernel-owner+w=401wt.eu-S1761222AbYDRUZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761222AbYDRUZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 16:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbYDRUZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 16:25:08 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:16457 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbYDRUZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 16:25:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=E8pIs9DKGAzw39hKSPhHpcxGSXKAvriPODFabEWbcmszcVjeCSJXzd8EPYPu91lSK54yLK5pXCv0JFoqnQiJ/J8qWTuel1trWZqffX8an+gGUsDvGJaHNVgSww37vw7/XKWAeaGQ6NSC1g99eR2jWuoKlf7dXqSF/OFepf/4dWk=
Message-ID: <48090395.6080202@gmail.com>
Date: Fri, 18 Apr 2008 22:24:53 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Bart Van Assche <bart.vanassche@gmail.com>
CC: Matthew <jackdachef@gmail.com>, torvalds@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rudolf Marek <r.marek@assembler.cz>,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Linux 2.6.25
References: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com> <e2e108260804181218u70f096dfr864cdd13d1d4d2f3@mail.gmail.com>
In-Reply-To: <e2e108260804181218u70f096dfr864cdd13d1d4d2f3@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2008 09:18 PM, Bart Van Assche wrote:
> On Fri, Apr 18, 2008 at 5:37 PM, Matthew <jackdachef@gmail.com> wrote:
>>  I've another "regression" to report for 2.6.25:
>>
>>  it's concerning much higher temperatures being read out by the
>>  "coretemp" kernel-module in comparison to 2.6.24* series
>>
>>  e.g. where temperatures were around 40-47°C they are now constantly
>>  jumping around 55-70°C (even in idle !)
> 
> The coretemp kernel module reports 25°C on my PC when idle, and 34°C
> after having performed some computations (lmbench2). This looks
> normal. This test has been performed with a vanilla 2.6.25 kernel and
> a Core 2 Duo E6750 CPU (Asus motherboard). The 2.6.22 and 2.6.24
> kernels report an incorrect temperature on the same system however
> (10°C). So there is either an issue with the patches that have been
> applied to your kernel or the behavior of the coretemp module for the
> 6600 and E6750 CPU's is different. Can you repeat the test with a
> vanilla 2.6.25 kernel ?
> 
> (Added Rudolf Marek in CC, the coretemp author.)

I see a change on my rrd graphs on Mar 5th 11:30 AM (from 25 to 40 average 
centigrades). This is when I booted 2.6.25-rc3-mm1 instead of 2.6.25-rc2-mm1, 
according to logs. [I have no idea whether the values were correct before or are 
correct now.]

I might bisect it, if needed.
