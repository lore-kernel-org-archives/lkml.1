Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbZAKW75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbZAKW75 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 17:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbZAKW7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 17:59:49 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:37652 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbZAKW7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 17:59:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ShYmkp+DMS2YkiZkD8cs0lPrTmEChtuYKhd0S4Fj49rbTq0z7sQ8j9b5SW2WLsi4gJ
         xyFlGTereCPuaAw9VUmYzVwvG1xY2oYCMra09E+euxCnRvSI3kURwbT/BdXf7rW9YJ7x
         MHsKxYIN3FIiMSR/XMgc+fvWaJAe1Q2AbdzXk=
Message-ID: <c4e36d110901111459p6d02892fwce0d89c52e62385e@mail.gmail.com>
Date: Sun, 11 Jan 2009 23:59:46 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Maciej Rutecki" <maciej.rutecki@gmail.com>
Subject: Re: 2.6.29-rc1 does not resume on Lenove T61
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
In-Reply-To: <8db1092f0901111215m5712caccvc0d2e5e7cb7e8f7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110901111152o63c4cda0j88f4c89950bd2b90@mail.gmail.com>
	 <8db1092f0901111215m5712caccvc0d2e5e7cb7e8f7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/11 Maciej Rutecki <maciej.rutecki@gmail.com>:
> 2009/1/11 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
>> Hi
>>
>> I've booted and tested 2.6.29-rc1 (c59765042f53a79a7a65585042ff463b69cb248c)
>>
>> I've observed that suspend is unusable - it goes to sleep - the sleep
>> LED is on. After few secs system turns on back itself - and stays in
>> some frozen state
>
> A have similar situation, one difference: I get blank screen during
> resume from suspend to ram. Also sometimes, like You, system turns on
> back itself.
>

So it looks like reverting this commit:

http://marc.info/?l=linux-kernel&m=123140019117968&w=4
(6fd9086a518d4f14213a32fe6c9ac17fabebbc1e)
(which is already a tracked regression)
fixes the problem with auto-resume

But the problem with deadlock in the resume phase is still there.

Zdenek
