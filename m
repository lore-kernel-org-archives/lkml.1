Return-Path: <linux-kernel-owner+w=401wt.eu-S1753773AbZEED7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbZEED7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 23:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbZEED7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 23:59:00 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:39172 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbZEED67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 23:58:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=kAmJ38BYHbmLCrGhNGnnh58MEU3s8T9sMoO+UduaopkBDnSHDAgbiahDjG/BPiIPD/
         JVL0QzfLCFpqYAsEsUesbFWnXfrXlaucFO24v3EzT9awD1+fltLdbCztpdH2Jh/8nyZ6
         umq2RHeh0vekhsFkM2dpWe3l9j0d+PSE7rj70=
Message-ID: <49FFB9BE.1090709@gmail.com>
Date: Tue, 05 May 2009 12:59:58 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com,
       sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com,
       stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp,
       zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com,
       sfr@canb.auug.org.au, grant.likely@secretlab.ca,
       paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com,
       adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org,
       schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net,
       rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com,
       bharrosh@panasas.com
Subject: Re: [GIT PATCH] block,scsi,ide: unify sector and data_len, take#2
References: <1241423927-11871-1-git-send-email-tj@kernel.org>
In-Reply-To: <1241423927-11871-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Tejun Heo wrote:
> Upon ack, please pull from the following git tree.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-unify-sector-and-data_len

git tree has been updated as per comments.

* Acked-by:'s added.

* Too early blk_rq_bytes() conversion in ide-tape pushed to later
  patch.

Both changes are minor and don't make any difference to the final
result.  The new commit is f7ff5f0d7cda0b0da5e7de36dd97ff75412bbe16.

Thanks.

-- 
tejun
