Return-Path: <linux-kernel-owner+w=401wt.eu-S1758796AbXLLQ3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796AbXLLQ3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 11:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758145AbXLLQ3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 11:29:25 -0500
Received: from ag-out-0708.google.com ([72.14.246.246]:61165 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757878AbXLLQ3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 11:29:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=fr9LlX793iV2seqsRyi1qUhr2HcFTm1BSNPeivqxswvuPSb1R7MmSs1S845T3TKIHIJW+vpdrJqpSjyybmcXIIVTTKKViQ6nMAh6pfdex1bxw1tR8K3hWFhth+MQhrf9pAQm50qCKpNnNt0zWqshrbwxuOqVbRwp/vtRa1s4K2U=
Message-ID: <47600C0C.9010002@keyaccess.nl>
Date: Wed, 12 Dec 2007 17:27:56 +0100
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Romano Giannetti <romanol@upcomillas.es>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFT] Port 0x80 I/O speed
References: <475F1DC6.5090403@keyaccess.nl> <1197453439.27741.6.camel@rukbat>
In-Reply-To: <1197453439.27741.6.camel@rukbat>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
From: Rene Herman <rene.herman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-12-07 10:57, Romano Giannetti wrote:

> On a laptop with a CoreDuo T2080/1.73GHz, but running on battery at 
> 800 MHz (on-demand):

> cycles: out 3575, in 2844

Okay, I'm going to ignore this one. This would be 4 microsecs but there are 
sleep states involved, and if a piece of hardware would work only when the 
system went to sleep I'd call it broken...

> With a cpu-hog running, cpufreq reporting 1.73GHz:

> cycles: out 3446, in 2652

So this one will do I guess. The test program disables interrupts and as 
such, the cpu-hog shouldn't have interfered with the measurement. Thanks!

Rene.
