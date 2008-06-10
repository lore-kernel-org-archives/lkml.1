Return-Path: <linux-kernel-owner+w=401wt.eu-S1755021AbYFJROL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbYFJROL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 13:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbYFJRNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 13:13:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:54583 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbYFJRNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 13:13:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=J24hYaMNWoVyfVs0E49HhdCZpdAN1lJ/ssjL9gmuR/YeFVDRlTAphK2mV1Z4kbUERX
         Tio/eFrsra33cbt8xw5Rf3Q7ANRzw0Z40xv0oL4w3IoZ87vfrh6sUVBElkJpnqMyZaZC
         zwGHFSr95fJGnk0F+AN/IvF78BGXjSlB92cvo=
Message-ID: <8bd0f97a0806101013w42b9028j5dfa38d654f3d05f@mail.gmail.com>
Date: Tue, 10 Jun 2008 13:13:52 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: blackfin drivers/net/smc91x.c build error
Cc: "Bryan Wu" <cooloney@kernel.org>, "Jeff Garzik" <jeff@garzik.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080610135349.GA30792@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080606162212.GC2201@cs181133002.pp.htv.fi>
	 <8bd0f97a0806061252n1cf5ee33i40ddf9f55588e242@mail.gmail.com>
	 <20080610135349.GA30792@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 9:53 AM, Adrian Bunk wrote:
> On Fri, Jun 06, 2008 at 03:52:09PM -0400, Mike Frysinger wrote:
>> On Fri, Jun 6, 2008 at 12:22 PM, Adrian Bunk wrote:
>> > drivers/net/smc91x.c fails as follows on blackfin:
>> > ...
>> >  CC      drivers/net/smc91x.o
>> > ...
>> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/net/smc91x.c:1863:36: error: macro "SMC_GET_MAC_ADDR" passed 2 arguments, but takes just 1
>> > ...
>>
>> it's a known issue (been known for quite a long time actually).  Bryan
>> has brought this up in the past already.
>
> Is my suggestion of reverting commit 099c736a470c8080a166e7a089f1e48e15f9947c
> correct or how else should it be resolved?

Bryan is taking care of it ... it may just stay broken in favor of
waiting for the merge from the net tree.

> This issue is the only remaining problem preventing that all blackfin
> defconfigs will compile in 2.6.26...

not really true.  but otherwise, failures dont go unnoticed as we have
automated nightly builds for all the relevant trees.
-mike
