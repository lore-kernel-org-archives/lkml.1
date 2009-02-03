Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbZBCOIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbZBCOIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 09:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbZBCOIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 09:08:37 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:4522 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbZBCOIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 09:08:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Fh1YcmyVCKotwzO6FgptZdVTVil54bX7Ba4Q13dirFsKuKWEoglSp9qGCud/8m41uA
         A5n45kU3n8rdewSUVNI2AHeJrLrkbKhkLjnQjxE8YwELSqa7oZFRXFvKmj+/bKrmd3Eo
         qBy+C7mO41bZHUAJljJeI5eXIBE1uG+/jEQtk=
MIME-Version: 1.0
In-Reply-To: <20090129220633.GA18603@elf.ucw.cz>
References: <2f11576a0901160518g52a3e70endc98fe4792a98b9b@mail.gmail.com>
	 <d6200be20901212213x1069762cpd377d04bc5a04a91@mail.gmail.com>
	 <20090128234209.A949.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <d6200be20901281851k45f9692em1379140c8951c195@mail.gmail.com>
	 <20090129220633.GA18603@elf.ucw.cz>
Date: Tue, 3 Feb 2009 23:08:35 +0900
X-Google-Sender-Auth: 28518adc52a1614f
Message-ID: <2f11576a0902030608q5ba07b2at38d4a0f1a7e13cc5@mail.gmail.com>
Subject: Re: lowmemory android driver not needed?
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Pavel Machek <pavel@suse.cz>
Cc: "Arve Hj?nnev?g" <arve@android.com>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Brian Swetland <swetland@google.com>, arve@google.com,
       San Mehat <san@android.com>, Robert Love <rlove@google.com>,
       linux-kernel@vger.kernel.org,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       "ext Juha Yrj??????" <juha.yrjola@solidboot.com>,
       viktor.rosendahl@nokia.com, Trilok Soni <soni.trilok@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

2009/1/30 Pavel Machek <pavel@suse.cz>:
> Hi!
>
>> I never expected it to be merged. I wrote it to allow us to ship a product.
>>
>> > The top problem is, this file stay on non proper place.
>> > then, MM folks don't review at all.
>> >
>> > I think this patch need to receive MM folks review.
>>
>> This patch solves two problems for us:
>> 1. It gives us more control over which process gets killed when we run
>> out of memory. This can easily be fixed in the regular oom killer
>> instead.
>> 2. It prevents the system from getting unusable due to excessive
>> demand paging. Before we added the low memory killer, we had devices
>> stuck for many minutes before the system managed to allocate enough
>> memory for the oom killer to kick in.
>> The second problem is the most critical and if it is solved, we will
>> not need this patch.
>
> Ok, maybe the best way forward is to create a "demo" that can be run
> on desktop machine,

good idea! :)


> where machine misbehaves (like becomes useless for
> 10 minutes before OOM killer kicks in), then draw attetion of
> Andrew/Nick/etc?
