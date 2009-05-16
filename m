Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbZEPOjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbZEPOjd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 10:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbZEPOjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 10:39:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:46361 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbZEPOjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 10:39:19 -0400
Message-ID: <4A0ECF8E.6000209@kernel.org>
Date: Sat, 16 May 2009 23:37:02 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, rusty@rustcorp.com.au,
       James.Bottomley@HansenPartnership.com, mike.miller@hp.com,
       donari75@gmail.com, paul.clements@steeleye.com, tim@cyberelk.net,
       Geert.Uytterhoeven@sonycom.com, davem@davemloft.net,
       Laurent@lvivier.info, jgarzik@pobox.com, jeremy@xensource.com,
       grant.likely@secretlab.ca, adrian@mcmen.demon.co.uk,
       sfr@canb.auug.org.au, bzolnier@gmail.com, petkovbb@googlemail.com,
       oakad@yahoo.com, drzeus@drzeus.cx, dwmw2@infradead.org,
       Markus.Lidel@shadowconnect.com, wein@de.ibm.com, schwidefsky@de.ibm.com,
       zaitcev@redhat.com, fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk
Subject: Re: [PATCH 11/18] swim: dequeue in-flight request
References: <1241751256-17435-1-git-send-email-tj@kernel.org> <1241751256-17435-12-git-send-email-tj@kernel.org> <4A0EC2AD.20704@ru.mvista.com>
In-Reply-To: <4A0EC2AD.20704@ru.mvista.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 16 May 2009 14:37:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
>   And without duplication:

Similar response as the if/else one on the other thread.  Is it really
any significantly better?  The 'duplication' here is basically one
liner after the peek/fetch change and when the duplication is minimal,
I usually find it clearer to put the loop condition at the while
clause itself.  If you think it's significantly better, please go
ahead and submit the patch but to me the change you're proposing is
basically cosmetic and not even a clearly better one at that.

Thanks.

-- 
tejun
