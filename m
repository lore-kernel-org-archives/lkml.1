Return-Path: <linux-kernel-owner+w=401wt.eu-S1753590AbZD2KUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbZD2KUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbZD2KUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:20:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:57463 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbZD2KUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:20:05 -0400
Message-ID: <49F828F4.10405@kernel.org>
Date: Wed, 29 Apr 2009 19:16:20 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: axboe@kernel.dk, Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org,
       "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
       bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com,
       mike.miller@hp.com, chirag.kantharia@hp.com, Eric.Moore@lsi.com,
       stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp,
       zaitcev@redhat.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca,
       paul.clements@steeleye.com, jesper.juhl@gmail.com, tim@cyberelk.net,
       jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com,
       David Woodhouse <dwmw2@infradead.org>, schwidefsky@de.ibm.com,
       ballabio_dario@emc.com, "David S. Miller" <davem@davemloft.net>,
       Paul Russell <rusty@rustcorp.com.au>, Markus.Lidel@shadowconnect.com,
       bharrosh@panasas.com
Subject: Re: [PATCH 04/10] block: implement blk_rq_pos/[cur_]sectors() and
 convert obvious ones
References: <1240996428-10159-1-git-send-email-tj@kernel.org> <1240996428-10159-5-git-send-email-tj@kernel.org> <alpine.LRH.2.00.0904291123440.31700@vixen.sonytel.be>
In-Reply-To: <alpine.LRH.2.00.0904291123440.31700@vixen.sonytel.be>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 10:16:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +static inline sector_t blk_rq_pos(struct request *rq)
>                                      ^
> 				     const?
>> +{
>> +	return rq->hard_sector;
>> +}
>> +
>>  extern unsigned int blk_rq_bytes(struct request *rq);
>>  extern unsigned int blk_rq_cur_bytes(struct request *rq);
>>  
>> +static inline unsigned int blk_rq_sectors(struct request *rq)
> 					     ^
> 					     const?
>> +{
>> +	return rq->hard_nr_sectors;
>> +}
>> +
>> +static inline unsigned int blk_rq_cur_sectors(struct request *rq)
> 						 ^
> 						 const?
>> +{
>> +	return rq->hard_cur_sectors;
>> +}
>> +

consts and acked-by added.

Thanks.

-- 
tejun
