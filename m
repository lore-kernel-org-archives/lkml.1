Return-Path: <linux-kernel-owner+w=401wt.eu-S932642AbZDHMDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642AbZDHMDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764958AbZDHLsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:48:17 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:59395 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764950AbZDHLsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:48:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kFSUYSdEWukv6kQdhJOGUfPpsq5u6sqxGznaiydRjR41K5FAYfsPJMzyKOf8tbiD7F
         BfR/Ic9jYP5yGTWDNoKCX+HQ7cyw6/hpBMKMMIhjaMiLX79XH9G1FjjZ2fXgYNB4+RBA
         C+7sUBTCjLV0vSJPG5pLHXEBuFCMR1JKf12m0=
MIME-Version: 1.0
In-Reply-To: <49DC8CCD.8030901@fastmail.fm>
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
	 <36ca99e90904080431o3fae1c2es555327578ab06d7@mail.gmail.com>
	 <49DC8CCD.8030901@fastmail.fm>
Date: Wed, 8 Apr 2009 13:48:12 +0200
Message-ID: <36ca99e90904080448g1252dfa6nce2389635f031575@mail.gmail.com>
Subject: Re: [PATCH 05/56] block: Remove void casts
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 13:38, Jack Stone <jwjstone@fastmail.fm> wrote:
> Bert Wesarg wrote:
>> Could you feed the patches through checkpatch.pl to find and fix these
>> style issues.
>>
>> (...)
>>
>> If typeof(c) == CommandList_struct*, that you could replace
>> sizeof(CommandList_struct) with sizeof(*c) to make the expression
>> shorter and fit into one line.
>>
> I was trying to avoid any changes beyond removing the void casts.
>
> I can go through and fix all these if people don't think thats too much to
> review in one go.
Right, thats a balancing act, and I think this change could be too much.

>
> I'll fix the line issues you've flagged up and resend the affected patched.
>

Bert
> Thanks,
>
> Jack
>
