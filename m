Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbZCELAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbZCELAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 06:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbZCEK74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 05:59:56 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:46598 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbZCEK7z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 05:59:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SiqXVmgTJt1MZYd4C6NLVnbaAnUZJcM6rJ9EOup1RpdFo3M25cUgroW9+Oq2lYIKtX
         lekdoWazf5I+yBkVzJJlyYK+yx2G/BqI220BdkDCF2khMi7G0iBsWh0qGjEkegYUomPh
         vWMU2Qz1OoxkK3FpjcPjtcOq9uoZxXe6PeMMU=
MIME-Version: 1.0
In-Reply-To: <20090227132658.GC1482@ucw.cz>
References: <1234646219.6609.37.camel@localhost.localdomain>
	 <20090227132658.GC1482@ucw.cz>
Date: Thu, 5 Mar 2009 10:59:51 +0000
Message-ID: <8b67d60903050259l2c108e13y86c96449be3b0cf6@mail.gmail.com>
Subject: Re: [RFC][PATCH] filesystem: VMUFAT filesystem
From: Adrian McMenamin <lkmladrian@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Adrian McMenamin <adrian@newgolddream.dyndns.info>,
       viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/27 Pavel Machek <pavel@ucw.cz>:
>
> Hi!
>
>> +     do {
>> +             /* Have we got a file? */
>> +             if (((__u8 *)bh->b_data)[(fno % 0x10) * 0x20] == 0) {
>
> u8 should be ok, no need for underscores. Applies to whole file.
>

In retrospect although this v1 worked (after a fashion), it was pretty
broken and so I am working on a fairly big rewrite. I was originally
hoping for something that might be ready to go into 2.6.30 but I think
that is gone now.
