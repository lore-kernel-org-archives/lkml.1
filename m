Return-Path: <linux-kernel-owner+w=401wt.eu-S932374AbXA1Dha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374AbXA1Dha (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 22:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbXA1Dha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 22:37:30 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:4302 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbXA1Dh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 22:37:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Dqeh4i9sDh89HK4n31s4q6HKx2ZcIGtGXhpKnXFmmh+7M2QsPxff4nLa1ZAqWEp0JZ7n9OJpepFVZghTzk5IPfTt3PLEZz/YMqa2vfxKr2SEVzXdNRkAALrpmrMVEGWxx6XhJOTDYwuiXxKwvv+uW9nl9MjV1qBxHc8YXUtyBm4=
Message-ID: <6bffcb0e0701271937m5849a5bfgb735f2e22dab5e2c@mail.gmail.com>
Date: Sun, 28 Jan 2007 04:37:27 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
Cc: "Andrew Morton" <akpm@osdl.org>, "Tilman Schmidt" <tilman@imap.cc>,
       linux-kernel@vger.kernel.org, "Hansjoerg Lipp" <hjlipp@web.de>
In-Reply-To: <200701280241.l0S2f2ga015847@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>
	 <6bffcb0e0701270837i1ec40560l6e61e8876177e9da@mail.gmail.com>
	 <45BBC444.8090109@imap.cc> <20070127134116.06bdadd8.akpm@osdl.org>
	 <200701280241.l0S2f2ga015847@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/01/07, Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:
> --- linux-2.6.20-rc6-mm1/block/elevator.c.dist  2007-01-26 14:30:36.000000000 -0500
> +++ linux-2.6.20-rc6-mm1/block/elevator.c       2007-01-27 19:57:02.000000000 -0500
> @@ -604,12 +604,6 @@ void elv_insert(request_queue_t *q, stru
>                  */
>                 rq->cmd_flags | REQ_SOFTBARRIER;
>
> -               /*
> -                * Most requeues happen because of a busy condition,
> -                * don't force unplug of the queue for that case.
> -                */
> -               unplug_it  0;
> -
>                 if (q->ordseq  0) {
>                         list_add(&rq->queuelist, &q->queue_head);
>                         break;
>
>
> (How did *that* one manage to compile for anybody??!?)

I have fixed this in my local tree, but I didn't send a patch because
Andrew has sent a git-block-borkage.patch three minutes earlier.

> After all that, I finally got a clean compile....  Maybe later I'll get brave
> and actually try to boot it. :)

Good luck :)

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)
