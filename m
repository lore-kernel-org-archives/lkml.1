Return-Path: <linux-kernel-owner+w=401wt.eu-S1756336AbYITBPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbYITBPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 21:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbYITBPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 21:15:16 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:44062 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175AbYITBPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 21:15:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=L14JArME8tvlKSfPjUBvKt+UOzHxb19BZmjKw4T/5HrDoZ8uNMCOltXGNBoNkM8bgc
         /vgXtOooeo6CJRAzecHzpOUoWtQzdaXd0r5WYF38Tg8/z7ZBNUkIGANiePbNf96oZ1Ul
         5KXa3RUSEpRx9kWXvUUAJm9reuEdDR60iV+4w=
Message-ID: <43e72e890809191815k3aad680cx6bc27759191e201@mail.gmail.com>
Date: Fri, 19 Sep 2008 18:15:12 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Steven Noonan" <steven@uplinklabs.net>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Senthilkumar Balasubramanian" 
	<Senthilkumar.Balasubramanian@atheros.com>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <43e72e890809191813n95579f5h83e92b0ba1f95a44@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com>
	 <f488382f0809190029n13b87ad1s153e5b983f301f31@mail.gmail.com>
	 <20080919142801.GA5816@senthil-lnx.users.atheros.com>
	 <alpine.LNX.2.00.0809190934001.22989@alcarin.uplinklabs.net>
	 <20080919175824.GA5626@senthil-lnx.users.atheros.com>
	 <20080919182322.GB7027@tesla>
	 <alpine.LNX.2.00.0809191630090.14961@alcarin.uplinklabs.net>
	 <20080919235305.GD11665@tesla>
	 <f488382f0809191701u2dbf8d22n6015c9f1f23c73be@mail.gmail.com>
	 <43e72e890809191813n95579f5h83e92b0ba1f95a44@mail.gmail.com>
X-Google-Sender-Auth: 5259a05155c92563
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 6:13 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:

> That is capital "i", this will show you the monitor results of number
> of interrupts on IRQ 17. You want to see if the rate of change is huge
> when you have latency issues. If not then its most likely

I meant most likely *NOT* an interrupt storm.

> an interrupt
> storm by ath9k (which is my suspect right now) but something else.
>
>  Luis
>
