Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbYEWMAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbYEWMAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 08:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbYEWMAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 08:00:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:51252 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbYEWMAS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 08:00:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lYh/lVNggo0CUkM/a9sUhDJs9tqBZLac1Xq7wxKALAu5zpDouttG1LZADmBTWJKL2WJ0dHOe1SL8yuS5ydugyf6fkTS9CRojjL1gIgy0FPNNXynpSxsV1T1QD4CcCqOy1pZrwESDqMIsK8D8VL2XbFutC/gTBEmHa8aS2qaiebw=
Message-ID: <7b9198260805230500l6b21a397m6951a2b1115a6f5@mail.gmail.com>
Date: Fri, 23 May 2008 13:00:17 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "=?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?=" <Uwe.Kleine-Koenig@digi.com>
Subject: Re: [PATCH 1/1] UIO: Add a write() function to enable/disable interrupts
Cc: "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Jan Altenberg" <jan.altenberg@linutronix.de>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Magnus Damm" <magnus.damm@gmail.com>
In-Reply-To: <20080523115815.GA6932@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080522192252.GB3226@local> <20080522192637.GC3226@local>
	 <7b9198260805221247t715660d1l4085fe8c310f89c@mail.gmail.com>
	 <20080522200814.GD3226@local>
	 <7b9198260805221326t6d23b757p2ffe646db70fceba@mail.gmail.com>
	 <20080523054115.GB28807@digi.com>
	 <7b9198260805230448x56bf3bd1kade6083c141a75f2@mail.gmail.com>
	 <20080523115815.GA6932@digi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/23 Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>:
> Hello Tom,
>
>> > Tom Spink wrote:
>> >> The added benefit is that the code becomes less complex, as you don't
>> >> have to check buffer sizes and copy the integer from userspace.
>> > AFAIK this is wrong.  You need to copy the integer from userspace in
>> > uio_ioctl.  Actually it's a value coming from user space, so you need to
>> > do it somewhere.
>>
>> Not really in this case.  It's not a *pointer* to a value in
>> userspace, so you don't need to copy anything.  If it was being used
>> to point to a memory location holding a value, then yes, it would need
>> to be copied across.  But in this case, it's just being used to pass
>> across 1 or 0.
> ah, OK, you're right.  Thanks for correcting my correction :-)

Heh, no problem.  My initial idea was just a thought anyway, just to
maintain a bit of extensibility if .write is ever needed for something
else. :-)

> Uwe

-- 
Tom Spink
