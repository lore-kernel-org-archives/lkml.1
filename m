Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbZD2Otk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbZD2Otk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 10:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757256AbZD2OtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 10:49:19 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:29903 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923AbZD2OtS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 10:49:18 -0400
MIME-Version: 1.0
In-Reply-To: <1240996428-10159-6-git-send-email-tj@kernel.org>
References: <1240996428-10159-1-git-send-email-tj@kernel.org> 
	<1240996428-10159-6-git-send-email-tj@kernel.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 29 Apr 2009 08:48:55 -0600
Message-ID: <fa686aa40904290748q410a055eq209a5382c9a5f3e7@mail.gmail.com>
Subject: Re: [PATCH 05/10] block: convert to pos and nr_sectors accessors
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, James.Bottomley@hansenpartnership.com,
       linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com,
       sshtylyov@ru.mvista.com, mike.miller@hp.com, chirag.kantharia@hp.com,
       Eric.Moore@lsi.com, stern@rowland.harvard.edu,
       fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com,
       Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au,
       paul.clements@steeleye.com, jesper.juhl@gmail.com, tim@cyberelk.net,
       jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com,
       dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com,
       davem@davemloft.net, rusty@rustcorp.com.au,
       Markus.Lidel@shadowconnect.com, bharrosh@panasas.com,
       Jeff Garzik <jgarzik@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 3:13 AM, Tejun Heo <tj@kernel.org> wrote:
> With recent cleanups, there is no place where low level driver
> directly manipulates request fields.  This means that the 'hard'
> request fields always equal the !hard fields.  Convert all
> rq->sectors, nr_sectors and current_nr_sectors references to
> accessors.
>
> [ Impact: use pos and nr_sectors accessors ]
>
> ---
[...]
>  drivers/block/xsysace.c             |   17 ++++++-----

Tested-by: and Acked-by: Grant Likely <grant.likely@secretlab.ca>

g.
