Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbZEEDnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbZEEDnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 23:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757178AbZEEDn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 23:43:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:52543 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756160AbZEEDnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 23:43:25 -0400
Message-ID: <49FFB598.4090205@kernel.org>
Date: Tue, 05 May 2009 12:42:16 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com,
       mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu,
       fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com,
       Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au,
       grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net,
       jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com,
       dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com,
       davem@davemloft.net, rusty@rustcorp.com.au,
       Markus.Lidel@shadowconnect.com, bharrosh@panasas.com
Subject: Re: [PATCH 04/11] block: implement blk_rq_pos/[cur_]sectors() and
 convert obvious ones
References: <1241423927-11871-1-git-send-email-tj@kernel.org> <1241423927-11871-5-git-send-email-tj@kernel.org> <49FEF174.6040505@ru.mvista.com>
In-Reply-To: <49FEF174.6040505@ru.mvista.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 05 May 2009 03:41:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
> Tejun Heo wrote:
> 
>> Implement accessors - blk_rq_pos(), blk_rq_sectors() and
>> blk_rq_cur_sectors() which return rq->sector, rq->hard_nr_sectors and
> 
>    Well, blk_rq_pos() returns rq->hard_sector, not rq->sector, doesn't it?

Right, description updated.

Thanks.

-- 
tejun
