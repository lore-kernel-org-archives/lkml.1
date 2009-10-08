Return-Path: <linux-kernel-owner+w=401wt.eu-S933007AbZJHSh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007AbZJHSh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 14:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932913AbZJHSh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 14:37:28 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:60470 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932902AbZJHSh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 14:37:26 -0400
Message-ID: <4ACE3124.4060109@billgatliff.com>
Date: Thu, 08 Oct 2009 13:36:20 -0500
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Trilok Soni <soni.trilok@gmail.com>
CC: Kyungmin Park <kyungmin.park@samsung.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, ben-linux@fluff.org
Subject: Re: [PATCH 5/6] haptic: Samsung SoCs PWM controlled haptic support
References: <20091007061822.GA7602@july> <5d5443650910081128l58f45148m87735185a0094c31@mail.gmail.com>
In-Reply-To: <5d5443650910081128l58f45148m87735185a0094c31@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trilok Soni wrote:
> Adding Bill Gatliff.
>
> Hi Kyungmin,
>
> Most of the driver looks fine. I have only one generic comment, but
> not for this driver:
>
> - Someone should really work on getting PWM framework (may be the one
> written by Bill Gatliff) into the kernel, because
>   if we don't do this and if new PWM controller provides it's own APIs
> then we can't leverage the chips using them, like the
>   case here for ISA1000 and ISA1200. These chips are using the pwm
> APIs exported by Samsung PWM controller, but it would
>   be painful to integrate other PWM controller if that has slightly
> little different API due to its nature.
>
>   So, it would be better to get one generic PWM framework mainline in
> the kernel.
>   

I can repost for review, if you like.

The only objection I received last time, IIRC, was that I proffered it 
as a "generic" API but only provided support for a couple of AT91 
parts.  I haven't had much time to add other support, so I haven't 
pushed for inclusion.

I would be happy to coordinate the development/migration of support to 
the API.  I can still do the AT91 parts and probably PXA, maybe 
OMAP3430/Beagleboard.  But I would need others to help me with the rest.

b.g.

-- 
Bill Gatliff
bgat@billgatliff.com

