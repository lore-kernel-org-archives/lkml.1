Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbYLJOfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbYLJOfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 09:35:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbYLJOex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 09:34:53 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:41388 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbYLJOex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 09:34:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=WbHrLYnl4HTPkmK2jPp5oByGeJsjztOoo6BnkHQ7ZdoVvwZqc8SPrt/LgBFnfukihO
         3hfshpSOeMrAPBDhNPXQkSrGKHAdM+LUp0iprJz5ysSqLOikhKRRscRjyDguYGtG0BkV
         As8lrml4E98hBG+EfPCpJnqzYh9Xzb8qPCdfc=
Message-ID: <493FD387.2030008@gmail.com>
Date: Wed, 10 Dec 2008 15:34:47 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: mmotm 2008-12-09-15-24: memory corruption (bio slab)
References: <1228917441-830-1-git-send-email-jirislaby@gmail.com> <20081210141109.GS23742@kernel.dk> <20081210143041.GT23742@kernel.dk>
In-Reply-To: <20081210143041.GT23742@kernel.dk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2008 03:30 PM, Jens Axboe wrote:
> On Wed, Dec 10 2008, Jens Axboe wrote:
>> But I notice that you are seeing this with bio-1, not bio-0. So this
>> must be the one of the pools created by md/dm. Does this help?
>>
>> I'll probably rework this a bit, perhaps we should just hide the back
>> padding functionality and force it to be used for vec inlining only.
>> Then it becomes invisible to the users.
> 
> Something like this, I'll fold it into the original patch.

Seems OK. The first patch fixes the issue, indeed. Thanks.
