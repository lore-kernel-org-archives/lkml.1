Return-Path: <linux-kernel-owner+w=401wt.eu-S1757845AbYLLJUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbYLLJUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 04:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYLLJTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 04:19:52 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38226 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbYLLJTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 04:19:51 -0500
Message-ID: <49422CAA.4070502@redhat.com>
Date: Fri, 12 Dec 2008 10:19:38 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH] Add preadv and pwritev system calls.
References: <49419EA7.6050308@redhat.com> <20081211234908.GA11305@infradead.org>
In-Reply-To: <20081211234908.GA11305@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> 
> Looks good, but you should Cc linux-arch so that arch maintainers get
> a heads up to wire up the syscalls.

Will do for the next version.

>> +	if (ret > 0)
>> +		add_rchar(current, ret);
>> +	inc_syscr(current);
>> +	return ret;
> 
> Could it be that these are missing for the compat case both for the existing
> readv/writev and your new syscalls?

Yep, seems so, I can't spot them anywhere in compat.c.
I'll sort that too.

thanks,
  Gerd
