Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbYIYVHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbYIYVHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 17:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbYIYVGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 17:06:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39341 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321AbYIYVGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 17:06:53 -0400
Message-ID: <48DBFD42.6030307@redhat.com>
Date: Thu, 25 Sep 2008 17:06:10 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Takashi Sato <t-sato@yk.jp.nec.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
       "axboe@kernel.dk" <axboe@kernel.dk>,
       "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] Add timeout feature
References: <20080908205337t-sato@mail.jp.nec.com> <20080908171119.GB22521@infradead.org>
In-Reply-To: <20080908171119.GB22521@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Sep 08, 2008 at 08:53:37PM +0900, Takashi Sato wrote:
>   
>> The timeout feature is added to "freeze ioctl" to solve a deadlock
>> when the freezer accesses a frozen filesystem. And new ioctl
>> to reset the timeout period is added to extend the timeout period.
>> For example, the freezer resets the timeout period to 10 seconds every 5
>> seconds.  In this approach, even if the freezer causes a deadlock by
>> accessing the frozen filesystem, it will be solved by the timeout
>> in 10 seconds and the freezer will be able to recognize that
>> at the next reset of timeout period.
>>     
>
> And as with all previous posting I still fundamentally disagree about
> the need of this functionality.  We don't need a timeout for freezing.
>
>   

I agree with Christoph here, I think that the timeout is unneeded.

Regards,

Ric

