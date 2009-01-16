Return-Path: <linux-kernel-owner+w=401wt.eu-S937136AbZAPUJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937136AbZAPUJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 15:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756490AbZAPUJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 15:09:22 -0500
Received: from smtp-out.google.com ([216.239.45.13]:53309 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463AbZAPUJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 15:09:19 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=Zuw8A9paunNMZPSoQCkPgJ8SxYtJixXP1qSs/+cy7oR3u4kNjU5HqIfFuq3sNH1ln
	JgZKNNNM2yp+HPkTQJUHQ==
MIME-Version: 1.0
In-Reply-To: <20090116.111059.205876014.davem@davemloft.net>
References: <1232117771.3224.21.camel@localhost.localdomain>
	 <20090116090928.e43c986e.akpm@linux-foundation.org>
	 <da824cf30901161102r67b9c31euc12fc95fb8330a07@mail.gmail.com>
	 <20090116.111059.205876014.davem@davemloft.net>
Date: Fri, 16 Jan 2009 12:09:14 -0800
Message-ID: <da824cf30901161209k7fa2d1cau27a2152c74256c4e@mail.gmail.com>
Subject: Re: [GIT PATCH] firs round of SCSI bug fixes for 2.6.29-rc1
From: Grant Grundler <grundler@google.com>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, James.Bottomley@hansenpartnership.com,
       torvalds@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.38
X-GMailtapped: grundler
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 11:10 AM, David Miller <davem@davemloft.net> wrote:
...
>>
>> TBH, I still wouldn't implement it the way LSI maintainers did.
>> I'm happy they are the maintainers and it's their call.
>
> They are doing things which effect the entire system, not just
> their driver.  So this doesn't fall under "maintainer's rights"

Agreed. This case is about a debug option which is normally disabled.
So most people will never see this.

The thread was more about how to make the failure visible in a
sane way WITHOUT the debug flag enabled. Then when the
debug flag is enabled, panic the machine as well.

> If they fail locally, that's fine and perfectly expected, but to take
> the whole machine out is another matter altogether.

Agreed.

thanks,
grant
