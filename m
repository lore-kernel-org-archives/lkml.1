Return-Path: <linux-kernel-owner+w=401wt.eu-S1758415AbZJIIeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415AbZJIIeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 04:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbZJIIeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 04:34:07 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:5706 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542AbZJIIeE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 04:34:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qDNQF9JQ2Dr2lHQ+eJSxnOa3s9FpPhbW9VBUShZ8g1unrhjuF9yMAjFMSxPAKhGRph
         3O+BbYq+mpf87nXnzNfreFGjc/WoXEXml7IlmfMvyqNOijFLo2XEWc+i9KzOkuiLgnLW
         zm6h7F133VcYQH8hMqampflL+AXnm+U0Dsj64=
MIME-Version: 1.0
In-Reply-To: <4ACE3124.4060109@billgatliff.com>
References: <20091007061822.GA7602@july>
	 <5d5443650910081128l58f45148m87735185a0094c31@mail.gmail.com>
	 <4ACE3124.4060109@billgatliff.com>
Date: Fri, 9 Oct 2009 14:02:57 +0530
Message-ID: <5d5443650910090132x5712b027j5d75d10821de5cfd@mail.gmail.com>
Subject: Re: [PATCH 5/6] haptic: Samsung SoCs PWM controlled haptic support
From: Trilok Soni <soni.trilok@gmail.com>
To: Bill Gatliff <bgat@billgatliff.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, ben-linux@fluff.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bill,

On Fri, Oct 9, 2009 at 12:06 AM, Bill Gatliff <bgat@billgatliff.com> wrote:
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

Two drivers are OK to begin with and for mainline. It is expected that
framework author may not have all parts with him to demonstrate a
thumbrule of atleast three driver per framework in-order to make it
mainline to test most the framework logic.

If mainline authors doesn't agree still, we can still target this
through drivers\stagic area through Greg KH. Please post your
refreshed version.

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
