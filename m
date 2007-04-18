Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbXDRQGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbXDRQGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 12:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbXDRQGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 12:06:38 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:39640 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbXDRQGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 12:06:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=qvtA0FOUsvhj2RKej52l1705yjq3ebrvCTQkF4XtT2bQx4F/pO7z6REvrwJ8N4mXL5MwCvw8C6Yed+ptOymVKWnNZhDnTotrsF0Vo1rctNLemUevr6AsGQbvLY7WyiGL9AXdsmVjesNZgxuYr3V0eaS7Hqv0LCuiDMyOK6umcOc=
Message-ID: <46264201.3060007@gmail.com>
Date: Thu, 19 Apr 2007 01:06:25 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg K-H <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>, dmitry.torokhov@gmail.com
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
References: <20070416193619.4659a847@gondolin.boeblingen.de.ibm.com>	<20070417184110.GJ10619@htj.dyndns.org> <20070418170652.7bee0952@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070418170652.7bee0952@gondolin.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Wed, 18 Apr 2007 03:41:10 +0900,
> Tejun Heo <htejun@gmail.com> wrote:
> 
> <patch>
> 
> OK, I hit a bit on the code. Once I saved a reference to the completion
> in kobject_cleanup, it seemed to survive a load/unload testloop for a
> module registering a device. However, I still dislike this "list of
> waiters" approach, it looks too complex...

Heh heh, I'm amazed it actually works.  Agreed that the list walking
isn't pretty but adding completion to each kobject still feels like too
much of overhead just for release waiting.  Any better ideas?

Thanks.

-- 
tejun
