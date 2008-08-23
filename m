Return-Path: <linux-kernel-owner+w=401wt.eu-S1755771AbYHWUqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbYHWUqG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 16:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbYHWUpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 16:45:55 -0400
Received: from po-out-1718.google.com ([72.14.252.152]:47093 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776AbYHWUpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 16:45:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TjzZLVzUA9BDyHY6VVQk5e+iSZwImtnFIgSZ+SS3+4tdnb8PxWOTYmk/NnyA19qnEY
         s3LNAgo6zyCiyhfYMP0lW4ekyX93Jib/RiAC2/8alwIn5p5XyvRXgNaLhXsFVR8ADik6
         0kka94UfZ1B4iZv291EK15EgEn5UUMOzH09l0=
Message-ID: <86802c440808231345u7c4f7710k5878928239507b10@mail.gmail.com>
Date: Sat, 23 Aug 2008 13:45:53 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Rufus & Azrael" <rufus-azrael@numericable.fr>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
Cc: "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>
In-Reply-To: <48B074E1.9020106@numericable.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48B0563B.2040207@numericable.fr>
	 <86802c440808231217q3eebc738v863170b178bb03ab@mail.gmail.com>
	 <48B067B3.6020008@numericable.fr>
	 <86802c440808231310hdafc30aw6931b77ea926338e@mail.gmail.com>
	 <48B06FF9.1030404@numericable.fr>
	 <86802c440808231328w5c6a3fa3s9be9d90ec1f30aa1@mail.gmail.com>
	 <48B07409.60905@numericable.fr>
	 <86802c440808231335n9214e38q5141a3560c698f76@mail.gmail.com>
	 <48B074E1.9020106@numericable.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2008 at 1:36 PM, Rufus & Azrael
<rufus-azrael@numericable.fr> wrote:
> Yinghai Lu wrote:
>>
>> cat /proc/timer_list
>>
>
> see file attached.
>
..
>
> Tick Device: mode:     1
> Clock Event Device: hpet
>  max_delta_ns:   149983003520
>  min_delta_ns:   3352
>  mult:           61496115
>  shift:          32
>  mode:           3
>  next_event:     9223372036854775807 nsecs
>  set_next_event: hpet_legacy_next_event
>  set_mode:       hpet_legacy_set_mode
>  event_handler:  tick_handle_oneshot_broadcast
> tick_broadcast_mask: 00000000
> tick_broadcast_oneshot_mask: 00000000
>

thanks

so it works..., need to find out where is the magic bit.

YH
