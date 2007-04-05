Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbXDEQ1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbXDEQ1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 12:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbXDEQ1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 12:27:01 -0400
Received: from bay0-omc3-s37.bay0.hotmail.com ([65.54.246.237]:52966 "EHLO
	bay0-omc3-s37.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753156AbXDEQ1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 12:27:00 -0400
Message-ID: <BAY20-F1927988DDB55A274D2DAAFF9650@phx.gbl>
X-Originating-IP: [88.114.147.249]
X-Originating-Email: [paapaa125@hotmail.com]
From: "Paa Paa" <paapaa125@hotmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Lower HD transfer rate with NCQ enabled?
Date: Thu, 05 Apr 2007 16:26:59 +0000
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
X-OriginalArrivalTime: 05 Apr 2007 16:26:59.0813 (UTC) FILETIME=[3C46D950:01C7779F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
>>>This is mostly a problem with the WD Raptor drive, and some other WD 
>>>drives.
>>>I have not yet encountered/noticed the problem with other brands.
>>
>>Sounds like this is a serious bug in the WD firmware.
>
>For personal systems, yes.  For servers, probably not a bug.

In my case the choice of IO scheduler affected the result of "hdparm -t" 
significantly. With Deadline I got identical result with NCQ and wihout NCQ. 
It was only with CFQ when I got worse results with NCQ than without it.

What might be the reason CFQ+NCQ gived so much worse throughput with "hdparm 
-t"?

_________________________________________________________________
Express yourself instantly with MSN Messenger! Download today it's FREE! 
http://messenger.msn.click-url.com/go/onm00200471ave/direct/01/

