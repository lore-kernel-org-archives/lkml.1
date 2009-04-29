Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbZD2Ou3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbZD2Ou3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 10:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbZD2OuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 10:50:07 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:34429 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbZD2OuF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 10:50:05 -0400
MIME-Version: 1.0
In-Reply-To: <1240996428-10159-5-git-send-email-tj@kernel.org>
References: <1240996428-10159-1-git-send-email-tj@kernel.org> 
	<1240996428-10159-5-git-send-email-tj@kernel.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 29 Apr 2009 08:49:43 -0600
Message-ID: <fa686aa40904290749v62a3cf70kc2d6b2a437b0bfe4@mail.gmail.com>
Subject: Re: [PATCH 04/10] block: implement blk_rq_pos/[cur_]sectors() and 
	convert obvious ones
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
       Markus.Lidel@shadowconnect.com, bharrosh@panasas.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 3:13 AM, Tejun Heo <tj@kernel.org> wrote:
> Implement accessors - blk_rq_pos(), blk_rq_sectors() and
> blk_rq_cur_sectors() which return rq->sector, rq->hard_nr_sectors and
> rq->hard_cur_sectors respectively and convert direct references of the
> said fields to the accessors.
>
> This is in preparation of request data length handling cleanup.
>
> [ Impact: cleanup ]
> ---
[...]
>  drivers/block/xsysace.c         |   10 +++++-----

Tested-by: and Acked-by: Grant Likely <grant.likely@secretlab.ca>

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
