Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbZD3GPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbZD3GPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 02:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbZD3GOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 02:14:50 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:57042 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbZD3GOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 02:14:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=XjWmEFI3k+snBo9aQWWN8u1ddNGxUDEzDQMobTzNxWs4VNELIFiWHuPwBzXiqizJuK
         VJfLbtBtJN3CW3qk/z4YlQmXuI76USCnQmQlSaJSrOqiEVG0kcMP4Ty26ERVVWGg71op
         P45DXStaqoZXl3yO1goE+oaDGW6vj5uu+MRfM=
Date: Thu, 30 Apr 2009 08:14:38 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
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
       adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org,
       schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net,
       rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com,
       bharrosh@panasas.com
Subject: Re: [PATCH 02/10] ide-tape: don't initialize rq->sector for rw
	requests
Message-ID: <20090430061438.GB6725@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Tejun Heo <tj@kernel.org>,
	axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org,
	linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org, bzolnier@gmail.com,
	petkovbb@googlemail.com, sshtylyov@ru.mvista.com,
	mike.miller@hp.com, chirag.kantharia@hp.com, Eric.Moore@lsi.com,
	stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp,
	zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com,
	sfr@canb.auug.org.au, grant.likely@secretlab.ca,
	paul.clements@steeleye.com, jesper.juhl@gmail.com, tim@cyberelk.net,
	jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com,
	dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com,
	davem@davemloft.net, rusty@rustcorp.com.au,
	Markus.Lidel@shadowconnect.com, bharrosh@panasas.com
References: <1240996428-10159-1-git-send-email-tj@kernel.org> <1240996428-10159-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1240996428-10159-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 06:13:40PM +0900, Tejun Heo wrote:
> rq->sector is set to the tape->first_frame but it's never actually
> used and not even in the correct unit (512 byte sectors).  Don't set
> it.
> 
> [ Impact: cleanup ]
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Borislav Petkov <petkovbb@gmail.com>

-- 
Regards/Gruss,
    Boris.
