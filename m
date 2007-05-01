Return-Path: <linux-kernel-owner+w=401wt.eu-S1423650AbXEAVR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423650AbXEAVR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423661AbXEAVR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:17:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:16866 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423650AbXEAVR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:17:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=TSp28Ra5kP3+YKOaglaK3p8GUsjSc5E/XuxEWKWZBNN/CkHhZIDiAdhu2n1QQmyPt28zrz/6Evl43lrPs5zsuDBYlh9N5FiRQPKw1MIIKAx1DDxDyOtUlNeX6CMIh/HN8QvDAFHaiK2EWXKxB8FfHOwgdcMmyPn8GGVvO3P9o3k=
Message-ID: <4637AE6D.4090408@gmail.com>
Date: Wed, 02 May 2007 01:17:33 +0400
From: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Paul Sokolovsky <pmiscml@gmail.com>
CC: ian <spyro@f2s.com>, kernel-discuss@handhelds.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [Kernel-discuss] Re: [RFC, PATCH 0/4] SoC base drivers
References: <1354376306.20070501080806@gmail.com>  <46374645.2030900@gmail.com> <1068016897.20070501173657@gmail.com>  <46376AD9.3020701@gmail.com> <1178042924.15769.5.camel@wirenth> <46379027.7050202@gmail.com> <281618366.20070501230902@gmail.com>
In-Reply-To: <281618366.20070501230902@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Paul,

Paul Sokolovsky wrote:
>> ASIC-related code (I mean core) forms additional platform layer, so I
>> suggest
>> adding ASIC helpers to generic platform code i.e. drivers/platform.c, but
>> ASIC drivers to drivers/asic/ directory.
>
>         There problem here is the same - our target chips are not
> just ASICs. 

You say they are chips so they are integrated circuits (ICs), they
are designed to solve some specific needs, so they are
application-specific ICs, i.e. ASICs, what's the problem?


> It just happens that the one we start with called such,
> but we have different ones too. 

Interesting what are they?
Power management ICs? Power management + audio
+ touchscreen + ADC + USB transceiver + UART + whatever
all such chips may be considered as ASICs.

> It's still important that they contain
> blocks with different functionality, and drivers we propose deal with
> basic, common functionality of chips. 

That different functionality blocks will be handled by appropriate
device drivers, and in general the drivers should not depend on
a particular ASIC but use common ASIC API.
But "common functionality" drivers are ASIC-specific.

> Now that it was pointed out that
> there's place in the tree for such drivers, it would be not wise to
> try to create another one.
>
>
>

Perhaps, so.  Actually, MFD  (multi functional device) doesn't
imply a platform-level device but ASIC seems does.



Thanks,
Dmitry


