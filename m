Return-Path: <linux-kernel-owner+w=401wt.eu-S1031498AbXEDTL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031498AbXEDTL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 15:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031503AbXEDTL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 15:11:59 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:42138 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031484AbXEDTL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 15:11:57 -0400
Message-ID: <463B858E.6060002@cfl.rr.com>
Date: Fri, 04 May 2007 15:12:14 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Francesco Pretto <ceztko@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no>  <fa.YHt2nIlQmoW5r2enmTSzsaySwH4@ifi.uio.no> <45DD0348.5040005@shaw.ca> <e5ab0f710702231235ucb559eerb3639ec312aa312a@mail.gmail.com>
In-Reply-To: <e5ab0f710702231235ucb559eerb3639ec312aa312a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 May 2007 19:12:10.0603 (UTC) FILETIME=[1D8C23B0:01C78E80]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15156.000
X-TM-AS-Result: No--6.361800-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Did anything ever come of this?  We still have users complaining about 
this.  Does this patch resolve the issue?  I can't seem to load it up 
right now; the site says it is down for maintenance.

Francesco Pretto wrote:
> 2007/2/22, Robert Hancock <hancockr@shaw.ca>:
>>
>> I believe it runs on suspend, but we don't run that code on normal
>> shutdown, do we?
>>
>> Tejun Heo had a patch for sd that could (optionally) trigger a START
>> STOP UNIT command to spin the disk down after synchronizing the cache
>> before shutdown, but I haven't heard anything of it lately..
>>
>>
> 
> Was this?
> http://www.nabble.com/(fwd)--PATCH--sd:-implement-stop_on_shutdown-t3049703.html 
> 
> 
> Not ready for inclusion yet? Tomorrow i'll give it a try, hoping it
> will apply to my conf. My actually shutdown procedure is to reboot on
> windows Xp and shutdown from there: i'm starting to become
> frustrated...

