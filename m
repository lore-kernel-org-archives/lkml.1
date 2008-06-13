Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbYFMOP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbYFMOP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 10:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754978AbYFMOPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 10:15:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:44711 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbYFMOPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 10:15:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Hg5zHi8ljSg/2FIKM8Ztd98NoNlaYzT0slyhxrqOZJrr2os6GA0EmPkzU41AMqHZcU
         HHdn+VsevYWi7o+FK5FAeZLwbTsss9U8bP6RdTayL3+lcUCtcyZ69cNgGxy8NsuDd+ui
         i8qJbkIJzRZS1facPqJu29Z+NpKVMHyE5Hg7o=
Message-ID: <c4e36d110806130715v4126d9b6vef69746e3b4e493b@mail.gmail.com>
Date: Fri, 13 Jun 2008 16:15:15 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Problem: Out of memory after 2days with 2GB RAM
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       riel@redhat.com
In-Reply-To: <200806131608.31803.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>
	 <200806131608.31803.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/13 Rafael J. Wysocki <rjw@sisk.pl>:
> On Thursday, 12 of June 2008, Zdenek Kabelac wrote:
>> Hello
>>
>> I'm attaching a trace where my machine has got into big troubles after
>> 2 day usage and several successful suspend/resumes (this seems to be
>> finally getting better now :))
>>
>> It looks like while there was a huge amount of buffers and caches -
>> system was unable to allocate few pages for kmalloc in iwl3945 driver
>> after resume.
>>
>> I've even tried to 3 > drop_cache  and reinsert iwl driver - but this
>> had fatal results - machine died completely with blinking caps lock -
>> and no oops in the log for this case:
>>
>> This is the commit aab2545fdd6641b76af0ae96456c4ca9d1e50dad  for the
>> 2.6.26-rc5 I've been in this case.
>
> Is this a regression from 2.6.25, BTW?

Well I've never seen this with 2.6.25 kernel - on the other hand
usually I've not been running machine for a longer period of time,
because suspend was failing too often I guess. Now it's more stable so
this bug has shown up.

It might be related to this issue as well http://lkml.org/lkml/2008/5/22/308

Zdenek
