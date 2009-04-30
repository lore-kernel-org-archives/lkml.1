Return-Path: <linux-kernel-owner+w=401wt.eu-S934083AbZD3Rxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934083AbZD3Rxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932936AbZD3RbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:31:03 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:16704 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765517AbZD3RbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:31:01 -0400
X-Trace: 191416754/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.109.173/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.41.109.173
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-SMTP-AUTH: 
X-MUA: Evolution 2.26.1 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlkGAPh8+UlQKW2t/2dsb2JhbACBUM8Jg38F
X-IronPort-AV: E=Sophos;i="4.40,274,1238972400"; 
   d="scan'208";a="191416754"
Subject: Re: [PATCH 05/10] block: convert to pos and nr_sectors accessors
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com,
       sshtylyov@ru.mvista.com, mike.miller@hp.com, chirag.kantharia@hp.com,
       Eric.Moore@lsi.com, stern@rowland.harvard.edu,
       fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com,
       Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au,
       grant.likely@secretlab.ca, paul.clements@steeleye.com,
       jesper.juhl@gmail.com, tim@cyberelk.net, jeremy@xensource.com,
       oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com,
       ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au,
       Markus.Lidel@shadowconnect.com, bharrosh@panasas.com,
       Jeff Garzik <jgarzik@pobox.com>
In-Reply-To: <1241037446.4516.2.camel@localhost.localdomain>
References: <1240996428-10159-1-git-send-email-tj@kernel.org>
	 <1240996428-10159-6-git-send-email-tj@kernel.org>
	 <1241037446.4516.2.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 30 Apr 2009 18:30:33 +0100
Message-Id: <1241112633.4698.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-29 at 21:39 +0100, Adrian McMenamin wrote:
> On Wed, 2009-04-29 at 18:13 +0900, Tejun Heo wrote:
> > With recent cleanups, there is no place where low level driver
> > directly manipulates request fields.  This means that the 'hard'
> > request fields always equal the !hard fields.  Convert all
> > rq->sectors, nr_sectors and current_nr_sectors references to
> > accessors.
> > 
> 
> Tested-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> Acked-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

Apologies, my sendmail was setup badly after a recent mail server crash
so this bounced alot. Hopefully it will reach everybody this time.

