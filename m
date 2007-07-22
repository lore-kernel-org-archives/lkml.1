Return-Path: <linux-kernel-owner+w=401wt.eu-S932077AbXGVWrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbXGVWrZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 18:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760288AbXGVWrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 18:47:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:3252 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759837AbXGVWrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 18:47:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=YCnNuuZNzjm2C/jY73xfnB9osITnEhiuMkwpztUT/0DWkAS99HTVY+HCoUSBBWfgwcEWcxsiYWWBOa+LBPXTfdF0qbJqL/KyuIH5KMquUHzT45yCV7VuIrd8VqxuIsFhwbrf2FJhE+UYLKz/bdNiWBnzzApo+2AqORvTkAT7fxk=
Message-ID: <46A3DDE4.1090701@googlemail.com>
Date: Mon, 23 Jul 2007 00:44:52 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: drivers/mtd/devices/doc2000.c - address of 'eccbuf' will always
 evaluate as 'true' , warnings
References: <46A349E6.3030207@googlemail.com> <20070722193449.GA11479@lazybastard.org> <46A3BE29.50501@googlemail.com> <20070722204325.GB11479@lazybastard.org>
In-Reply-To: <20070722204325.GB11479@lazybastard.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> On Sun, 22 July 2007 22:29:29 +0200, Gabriel C wrote:
>> @@ -896,25 +896,6 @@ static int doc_write(struct mtd_info *mtd, loff_t to, size_t len,
>>  		/* Let the caller know we completed it */
>>  		*retlen += len;
>>  
>> -		if (eccbuf) {
>> -			unsigned char x[8];
>> -			size_t dummy;
>> -			int ret;
>> -
>> -			/* Write the ECC data to flash */
>> -			for (di=0; di<6; di++)
>> -				x[di] = eccbuf[di];
>> -
>> -			x[6]=0x55;
>> -			x[7]=0x55;
>> -
>> -			ret = doc_write_oob_nolock(mtd, to, 8, &dummy, x);
>> -			if (ret) {
>> -				mutex_unlock(&this->lock);
>> -				return ret;
>> -			}
>> -		}
>> -
>>  		to += len;
>>  		left -= len;
>>  		buf += len;
> 
> You should remove the condition, but not the conditional code.

Sorry , I was away from keyboard.

Then I can't understand what this code is doing :/ 

So let Thomas or someone know this code fix it.

> 
> Jörn
> 

Regards,

Gabriel
