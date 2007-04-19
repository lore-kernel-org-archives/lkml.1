Return-Path: <linux-kernel-owner+w=401wt.eu-S637746AbXDSMpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S637746AbXDSMpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 08:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S637747AbXDSMpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 08:45:53 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46873 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S637744AbXDSMpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 08:45:51 -0400
Message-ID: <4627644E.7010002@bull.net>
Date: Thu, 19 Apr 2007 14:45:02 +0200
From: Valerie Clement <valerie.clement@bull.net>
User-Agent: Thunderbird 1.5.0.4 (Windows/20060516)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Performance degradation with FFSB between 2.6.20 and 2.6.21-rc7
References: <462622F8.10107@bull.net> <20070419090346.GE20928@kernel.dk> <462736FC.3090902@bull.net> <20070419115840.GA11780@kernel.dk>
In-Reply-To: <20070419115840.GA11780@kernel.dk>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 19/04/2007 14:48:26,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 19/04/2007 14:48:28,
	Serialize complete at 19/04/2007 14:48:28
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Thu, Apr 19 2007, Valerie Clement wrote:
>> Jens Axboe wrote:
>>> Please tell me how you are running ffsb, and also please include a
>>> dmessg from a booted system.
>>>
>> Hi,
>> our mails crossed! please see my response to Andrew.
>> You could reproduce the problem with dd command as suggested, it's more 
>> easy.
>> I'm sending you the dmesg info. For my tests I used the scsci sdc device.
> 
> Thanks, it does. Can you try one thing for me? If you run the test on
> sdc, try doing:
> 
> # echo 64 > /sys/block/sdc/queue/iosched/quantum
> 
> and repeat the test.
> 

OK, that's done.

With the change of quantum, the throughput scores are now a little bit 
better in 2.6.21 than in 2.6.20.

   Valérie

