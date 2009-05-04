Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbZEDTtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbZEDTtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 15:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbZEDTs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 15:48:58 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:34548 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753108AbZEDTs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 15:48:57 -0400
X-Trace: 189390478/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.109.173/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.41.109.173
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-SMTP-AUTH: 
X-MUA: Evolution 2.26.1 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiQGAE/j/klQKW2t/2dsb2JhbACBUM07g30F
X-IronPort-AV: E=Sophos;i="4.40,293,1238972400"; 
   d="scan'208";a="189390478"
Subject: Re: [PATCH 05/11] block: convert to pos and nr_sectors accessors
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org,
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
In-Reply-To: <1241423927-11871-6-git-send-email-tj@kernel.org>
References: <1241423927-11871-1-git-send-email-tj@kernel.org>
	 <1241423927-11871-6-git-send-email-tj@kernel.org>
Content-Type: text/plain
Date: Mon, 04 May 2009 20:48:20 +0100
Message-Id: <1241466500.6677.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-04 at 16:58 +0900, Tejun Heo wrote:
> With recent cleanups, there is no place where low level driver
> directly manipulates request fields.  This means that the 'hard'
> request fields always equal the !hard fields.  Convert all
> rq->sectors, nr_sectors and current_nr_sectors references to
> accessors.
> 
> [ Impact: use pos and nr_sectors accessors ]
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> Tested-by: Grant Likely <grant.likely@secretlab.ca>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> Tested-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> Acked-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

I have re-tested this on the Dreamcast and it still works :)

Tested-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
Acked-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

