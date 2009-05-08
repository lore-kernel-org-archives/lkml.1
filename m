Return-Path: <linux-kernel-owner+w=401wt.eu-S1763219AbZEHTyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763219AbZEHTyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 15:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbZEHTyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 15:54:19 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:2080 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753339AbZEHTyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 15:54:18 -0400
X-Trace: 192041966/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.64.35/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.41.64.35
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-SMTP-AUTH: 
X-MUA: Evolution 2.26.1 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtwEAHsqBEpQKUAj/2dsb2JhbACBUM9Kg30F
X-IronPort-AV: E=Sophos;i="4.40,318,1238972400"; 
   d="scan'208";a="192041966"
Subject: Re: [PATCH 16/18] gdrom: dequeue in-flight request
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, rusty@rustcorp.com.au,
       James.Bottomley@HansenPartnership.com, mike.miller@hp.com,
       donari75@gmail.com, paul.clements@steeleye.com, tim@cyberelk.net,
       Geert.Uytterhoeven@sonycom.com, davem@davemloft.net,
       Laurent@lvivier.info, jgarzik@pobox.com, jeremy@xensource.com,
       grant.likely@secretlab.ca, sfr@canb.auug.org.au, bzolnier@gmail.com,
       petkovbb@googlemail.com, sshtylyov@ru.mvista.com, oakad@yahoo.com,
       drzeus@drzeus.cx, dwmw2@infradead.org, Markus.Lidel@shadowconnect.com,
       wein@de.ibm.com, schwidefsky@de.ibm.com, zaitcev@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk
In-Reply-To: <1241751256-17435-17-git-send-email-tj@kernel.org>
References: <1241751256-17435-1-git-send-email-tj@kernel.org>
	 <1241751256-17435-17-git-send-email-tj@kernel.org>
Content-Type: text/plain
Date: Fri, 08 May 2009 20:53:45 +0100
Message-Id: <1241812425.18200.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-08 at 11:54 +0900, Tejun Heo wrote:
> gdrom already dequeues and fully completes requests on normal path and
> the error paths can be easily converted to do so too.  Clean it up and
> dequeue requests on error paths too.
> 
> While at it remove superflous blk_fs_request() && !blk_rq_sectors()
> condition check.
> 
> [ Impact: dequeue in-flight request, cleanup ]
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> ---

Tested-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
Acked-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

