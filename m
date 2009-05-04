Return-Path: <linux-kernel-owner+w=401wt.eu-S1751521AbZEDEbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbZEDEbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 00:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbZEDEbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 00:31:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:60863 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbZEDEbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 00:31:09 -0400
Message-ID: <49FE6CEC.2060802@kernel.org>
Date: Mon, 04 May 2009 13:19:56 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>, axboe@kernel.dk,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com,
       mike.miller@hp.com, chirag.kantharia@hp.com, Eric.Moore@lsi.com,
       stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp,
       zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com,
       sfr@canb.auug.org.au, grant.likely@secretlab.ca,
       paul.clements@steeleye.com, jesper.juhl@gmail.com, tim@cyberelk.net,
       jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com,
       dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com,
       davem@davemloft.net, rusty@rustcorp.com.au,
       Markus.Lidel@shadowconnect.com, "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 08/10] block: cleanup rq->data_len usages
References: <1240996428-10159-1-git-send-email-tj@kernel.org>	 <1240996428-10159-9-git-send-email-tj@kernel.org>	 <49F9AC04.9060403@panasas.com> <1241105757.3320.1.camel@mulgrave.int.hansenpartnership.com> <49FCF423.7040609@kernel.org> <49FDA164.3030806@panasas.com>
In-Reply-To: <49FDA164.3030806@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 04 May 2009 04:20:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Boaz Harrosh wrote:
> OK, NP. But in this case please note on the side all the places you
> think might be suspect for blk_rq_bytes()/blk_rq_sectors()
> cosolidation and post the list. Because it is now that you are going
> over the code and it is now that you touch exactly all these places.
> 
> You could even put a "TODO:" comments on all these places in this
> patch. So to draw later patches that audit and remove the TODO:.

Heh... okay.  I'll add a patch for the sweep conversion.

> (Or in trivial places like above that are safe even before these
> patches, just convert them silently, in the sense of least traffic)

I really don't want to do that.  Things which might look trivial often
break things and this part of API has been quite fragile, so I'd
rather put those changes after the actual unification for, if nothing
else, documentation.

> But sure I will see what I can help and send patches for. Tell me
> when you think this is stable enough for me to add patches on top
> of.

Yeap, I just finished saving the wasteland, so the refreshed patchset
will be posted later today.  :-)

Thanks.

-- 
tejun
