Return-Path: <linux-kernel-owner+w=401wt.eu-S1753029AbYBHWAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbYBHWAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:00:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbYBHV7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:59:31 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:2937 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759234AbYBHV7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:59:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=gV0Izp1OMfOiOFondJ0slIFuIWNAhUqO21TZ92a6TH7iWex1gRXCcrUqrzkUYH1ksGybbKg2Jle6hZGy00qGitskS4+LiQHk/4TFkCwcP4Jc+w4IolWsyhExVHLBHo1+My+e16A8gCah8PqpF5UGeKMtY7c/TwzxITl7UDY2+xk=
Message-ID: <47ACD0BD.9070609@gmail.com>
Date: Fri, 08 Feb 2008 22:59:25 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/1] mxser: convert large macros to functions
References: <1202462208-6171-1-git-send-email-jirislaby@gmail.com> <20080208134115.9289b7c7.akpm@linux-foundation.org>
In-Reply-To: <20080208134115.9289b7c7.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2008 10:41 PM, Andrew Morton wrote:
> On Fri,  8 Feb 2008 10:16:48 +0100
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> From: Christoph Hellwig <hch@lst.de>
>>
>> From: Christoph Hellwig <hch@lst.de>
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> Acked-by: Jiri Slaby <jirislaby@gmail.com>
> 
> This should have been Signed-off-by: - you were in the delivery path.
> 
> I'll make that change.
> 
>> --- a/drivers/char/mxser.c
>> +++ b/drivers/char/mxser.c
> 
> Has this been runtime tested?

Not by me, only compiled, sparsed, checkpatched and reviewed on my side (hence 
the ack).

>> -	DISABLE_MOXA_MUST_ENCHANCE_MODE(io);
>> +	mxser_disable_must_enchance_mode(io);
> 
> hm, what's all this "enchance" stuff throughout the driver?  Did it mean
> "enhance"?

I have no idea. It seems so.
