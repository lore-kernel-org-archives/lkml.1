Return-Path: <linux-kernel-owner+w=401wt.eu-S1761838AbYDNUzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761838AbYDNUzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 16:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761451AbYDNUzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 16:55:24 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33166 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761423AbYDNUzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 16:55:22 -0400
Message-ID: <4803C4A8.7020304@garzik.org>
Date: Mon, 14 Apr 2008 16:55:04 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, me@bobcopeland.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
References: <20080412205544.5e12a7d4.akpm@linux-foundation.org> <20080413080130.GA9622@infradead.org> <20080413012001.8d7967f4.akpm@linux-foundation.org> <20080413082815.GA20108@infradead.org> <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu> <1208121358.2700.4.camel@shinybook.infradead.org> <20080413154459.4b2f125d.akpm@linux-foundation.org> <20080413234920.63711ca7@core> <20080413161014.cb06964c.akpm@linux-foundation.org> <20080414091639.4bd3879d@core> <20080414084141.GA29113@infradead.org>
In-Reply-To: <20080414084141.GA29113@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Apr 14, 2008 at 09:16:39AM +0100, Alan Cox wrote:
>> I think the exceed them quite easily. The costs are almost nil, while
>> merging this provides another nice example fs (and one much easier to
>> follow than ext*) for hardware that does have a few users and will no
>> doubt get many more
>>
>> I wasn't aware Linus had introduced a new rule required 500 people sign
>> up to use a feature before it gets added ?
> 
> I'm also very surprised by this, especially as it seems to be applied
> very selectively.  This filesystems is an almost 0 maintainance burden
> unlike a lot of really crappy driver we're shoving in constantly.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Agreed.  And adding to the pile-on, I think that we should be 
_encouraging_ rather than discouraging innovative new filesystems.

I rather dislike limiting filesystem maintenance to the "old guard".

See comments like those on Evgeniy's blog: 
http://tservice.net.ru/~s0mbre/blog/devel/fs/2008_04_14.html

Sure we do not need to merge every filesystem under the sun, or things 
that much better belong in userspace (sshfs), but AFAICS there is not a 
huge increase in maintenance cost to add a new kernel filesystem.

	Jeff


