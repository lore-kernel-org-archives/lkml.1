Return-Path: <linux-kernel-owner+w=401wt.eu-S1751668AbXB0QRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbXB0QRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 11:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbXB0QRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 11:17:20 -0500
Received: from il.qumranet.com ([82.166.9.18]:49076 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbXB0QRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 11:17:19 -0500
Message-ID: <45E45915.20204@argo.co.il>
Date: Tue, 27 Feb 2007 18:15:17 +0200
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: suparna@in.ibm.com, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: A quick fio test (was Re: [patch 00/13] Syslets, "Threadlets",
 generic AIO support, v3)
References: <20070223135525.GA31569@in.ibm.com> <20070223145826.GA32465@elte.hu> <20070223151515.GA12960@in.ibm.com> <20070223162508.GA16782@kernel.dk> <20070223171348.GA27838@in.ibm.com> <20070226135736.GF3822@kernel.dk> <20070226141315.GA15631@in.ibm.com> <20070226144548.GH3822@kernel.dk> <20070227043331.GA29942@in.ibm.com> <45E43827.4000102@argo.co.il> <20070227152507.GA8294@elte.hu>
In-Reply-To: <20070227152507.GA8294@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Avi Kivity <avi@argo.co.il> wrote:
>
>   
>> But what about cpu usage?  At these low levels, the cpu is probably 
>> underutilized.  It would be interesting to measure cpu time per I/O 
>> request (or, alternatively, use an I/O subsystem that can saturate the 
>> processors).
>>     
>
> yeah - that's what testing on ramdisk (Jens') or on a loopback block 
> device (mine) approximates to a certain degree.
>
>   

Ramdisks or fully cached loopback return immediately, so cache thrashing 
effects don't show up.

Maybe a device mapper delay target or nbd + O_DIRECT can insert delays 
to make the workload more disk-like.




-- 
error compiling committee.c: too many arguments to function

