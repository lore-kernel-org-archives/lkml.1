Return-Path: <linux-kernel-owner+w=401wt.eu-S1760150AbZJHXwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbZJHXwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 19:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760097AbZJHXwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 19:52:34 -0400
Received: from mail-vw0-f203.google.com ([209.85.212.203]:54752 "EHLO
	mail-vw0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760094AbZJHXwd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 19:52:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bpP+rl0q+NancozQ/eozMyzr2jdCaaGpLsmenMdzs1gTu4MaCjKfpHjyQucwmMcNKa
         YwxwGa75aORWi6igtHK1gkpGNeKpb5+w0zHYKMqvAa4bJrKgoLwYICs82YfB6QjycyaJ
         roZjqTGdPg79G+y80WYy5GkExtkkS2RzvMQLo=
MIME-Version: 1.0
In-Reply-To: <4ACE3124.4060109@billgatliff.com>
References: <20091007061822.GA7602@july>
	 <5d5443650910081128l58f45148m87735185a0094c31@mail.gmail.com>
	 <4ACE3124.4060109@billgatliff.com>
Date: Fri, 9 Oct 2009 08:51:56 +0900
X-Google-Sender-Auth: 236ad48b7c00b1c5
Message-ID: <9c9fda240910081651n7c30bcd1y931ee1d58198e2c3@mail.gmail.com>
Subject: Re: [PATCH 5/6] haptic: Samsung SoCs PWM controlled haptic support
From: Kyungmin Park <kmpark@infradead.org>
To: Bill Gatliff <bgat@billgatliff.com>
Cc: Trilok Soni <soni.trilok@gmail.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, ben-linux@fluff.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I agree use the generic PWM framework. But it's not support on Samsung SoCs yet.

I also wrote the OMAP driver. Of course it uses the OMAP specific PWM drivers.

I think after full integration of PWM frameworks as GPIO does, It will
be replace with new PWM frameworks.

Thank you,
Kyungmin Park


On Fri, Oct 9, 2009 at 3:36 AM, Bill Gatliff <bgat@billgatliff.com> wrote:
> Trilok Soni wrote:
>>
>> Adding Bill Gatliff.
>>
>> Hi Kyungmin,
>>
>> Most of the driver looks fine. I have only one generic comment, but
>> not for this driver:
>>
>> - Someone should really work on getting PWM framework (may be the one
>> written by Bill Gatliff) into the kernel, because
>>  if we don't do this and if new PWM controller provides it's own APIs
>> then we can't leverage the chips using them, like the
>>  case here for ISA1000 and ISA1200. These chips are using the pwm
>> APIs exported by Samsung PWM controller, but it would
>>  be painful to integrate other PWM controller if that has slightly
>> little different API due to its nature.
>>
>>  So, it would be better to get one generic PWM framework mainline in
>> the kernel.
>>
>
> I can repost for review, if you like.
>
> The only objection I received last time, IIRC, was that I proffered it as a
> "generic" API but only provided support for a couple of AT91 parts.  I
> haven't had much time to add other support, so I haven't pushed for
> inclusion.
>
> I would be happy to coordinate the development/migration of support to the
> API.  I can still do the AT91 parts and probably PXA, maybe
> OMAP3430/Beagleboard.  But I would need others to help me with the rest.
>
> b.g.
>
> --
> Bill Gatliff
> bgat@billgatliff.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
