Return-Path: <linux-kernel-owner+w=401wt.eu-S1758116AbZEEDom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbZEEDom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 23:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbZEEDo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 23:44:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:52578 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbZEEDo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 23:44:28 -0400
Message-ID: <49FFB5B3.3000202@kernel.org>
Date: Tue, 05 May 2009 12:42:43 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com,
       sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com,
       stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp,
       zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com,
       sfr@canb.auug.org.au, grant.likely@secretlab.ca,
       paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com,
       oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com,
       ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au,
       Markus.Lidel@shadowconnect.com, bharrosh@panasas.com,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 05/11] block: convert to pos and nr_sectors accessors
References: <1241423927-11871-1-git-send-email-tj@kernel.org>	 <1241423927-11871-6-git-send-email-tj@kernel.org> <1241466500.6677.2.camel@localhost.localdomain>
In-Reply-To: <1241466500.6677.2.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 05 May 2009 03:41:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian McMenamin wrote:
> On Mon, 2009-05-04 at 16:58 +0900, Tejun Heo wrote:
>> With recent cleanups, there is no place where low level driver
>> directly manipulates request fields.  This means that the 'hard'
>> request fields always equal the !hard fields.  Convert all
>> rq->sectors, nr_sectors and current_nr_sectors references to
>> accessors.
>>
>> [ Impact: use pos and nr_sectors accessors ]
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Acked-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
>> Tested-by: Grant Likely <grant.likely@secretlab.ca>
>> Acked-by: Grant Likely <grant.likely@secretlab.ca>
>> Tested-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
>> Acked-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> 
> I have re-tested this on the Dreamcast and it still works :)
> 
> Tested-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> Acked-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

Thanks.  Much appreciated.

-- 
tejun
