Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbYBHVip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbYBHVip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbYBHVih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:38:37 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:44580 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbYBHVig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:38:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=EMoLAHjwCUDeRK17vbItei1/M8kxOpQKPEUVg9wNb8lEP6VtsHLAiVcOgJZ+7xqsf/v70I1gHbIhFctkj9tr4s3Om2mPdlXeHF+cdwjT2R9oMqHcA+SKj6SkuHUlvhO+iRzYkpxM7HDlVkyPDr4HqJ2bSV9+n32naTa4K24JoKM=
Message-ID: <47ACCBD4.1000502@gmail.com>
Date: Fri, 08 Feb 2008 22:38:28 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 1/1] tty: BKL pushdown fix
References: <20080208154208.0efd6885@core>	<1202497487-32550-1-git-send-email-jirislaby@gmail.com> <20080208133530.0e453c50.akpm@linux-foundation.org>
In-Reply-To: <20080208133530.0e453c50.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2008 10:35 PM, Andrew Morton wrote:
> On Fri,  8 Feb 2008 20:04:47 +0100
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> --- a/drivers/char/n_hdlc.c
>> +++ b/drivers/char/n_hdlc.c
>> @@ -579,7 +579,7 @@ static ssize_t n_hdlc_tty_read(struct tty_struct *tty, struct file *file,
>>  	}
>>  
>>  	lock_kernel();
>> -	
>> +
> 
> yeah.  I have a little script..

Note that it isn't only whitespace fixes in the patch.

I have one more -fix.
