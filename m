Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbZBGUs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbZBGUs1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 15:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbZBGUsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 15:48:18 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:52662 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbZBGUsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 15:48:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=DhtVDLe5Mu4Gv8GcPEUZsAd2JyS6+M127GQ+tkNJFaKhGSkHE/KHjNsIDAs/+yErn0
         i7r9366ikvuDEaBfNzZxFNurY0MEZo4lb4U9EcdZDT1Fi6IHElFTZ4jiS8rEC2ZH+tlr
         opr8z8c4v5mTTQ3c8+AojucV57/7sxGGTtGjY=
Message-ID: <498DF388.1050906@gmail.com>
Date: Sat, 07 Feb 2009 21:48:08 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, pavel@suse.cz,
       rjw@sisk.pl, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/1] x86_64: fix early_gdt_descr_base mangling
References: <1234028402-4747-1-git-send-email-jirislaby@gmail.com> <73c1f2160902071243t1c00ad1fqf1ae286995f1c1d9@mail.gmail.com>
In-Reply-To: <73c1f2160902071243t1c00ad1fqf1ae286995f1c1d9@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Gerst wrote:
>> @@ -425,7 +426,7 @@ NEXT_PAGE(level2_spare_pgt)
>>  early_gdt_descr:
>>        .word   GDT_ENTRIES*8-1
>>  early_gdt_descr_base:
>> -       .quad   per_cpu__gdt_page
>> +       .quad   0
> 
> The add of the load address isn't done on UP, so this breaks it.

Ah, I see.

> Actually, hold off on this patch.

Ok, thanks, holding on...
