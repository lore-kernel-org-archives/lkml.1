Return-Path: <linux-kernel-owner+w=401wt.eu-S1758308AbZFCPy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308AbZFCPy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbZFCPyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:54:51 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:16242 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZFCPyv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:54:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VuURNw/zSyT+cbw4rR4bXQIsIuoPVcu10cMUyzFHoj+5YuA2f4n/cUi4t26Sw9ACTF
         xKjjIcB8y94jIm0PCvc7SDBq1cyix6OdTu3t5+NShQOxuUhQrpCBfBpspGGWwURKaH7Z
         iYHifAL1SuwphKZGMCKmLRwU7WTDDZ32exxOI=
MIME-Version: 1.0
In-Reply-To: <9e4733910906030838o7313c311je3545cd974d3edd5@mail.gmail.com>
References: <4A255B21.8040002@gersys.de>
	 <20090602171527.GA8745@oksana.dev.rtsoft.ru>
	 <4A266FB2.2040902@gersys.de>
	 <20090603132217.GA18353@oksana.dev.rtsoft.ru>
	 <9e4733910906030838o7313c311je3545cd974d3edd5@mail.gmail.com>
Date: Wed, 3 Jun 2009 21:24:52 +0530
Message-ID: <5d5443650906030854h40e98ff9tb2bd23a0f5e8dec6@mail.gmail.com>
Subject: Re: PWM class? (was: Re: MPC52xx simple GPIO support)
From: Trilok Soni <soni.trilok@gmail.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: avorontsov@ru.mvista.com, Stefan Strobl <nst@gersys.de>,
       ppc-dev <linuxppc-dev@ozlabs.org>, linux-kernel@vger.kernel.org,
       Bill Gatliff <bgat@billgatliff.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

On Wed, Jun 3, 2009 at 9:08 PM, Jon Smirl <jonsmirl@gmail.com> wrote:
> On Wed, Jun 3, 2009 at 9:22 AM, Anton Vorontsov
> <avorontsov@ru.mvista.com> wrote:
>> On Wed, Jun 03, 2009 at 02:42:26PM +0200, Stefan Strobl wrote:
>> [...]
>>> The led class provides support for setting the brightness, which
>>> obviously the gpio driver doesn't support. The hardware (mpc52xx_gpt)
>>> would support it in PWM mode though. I'm now wandering how this could be
>>> best implemented.
>>>
>>> 1) - Create some PWM class similar to the GPIO class
>>>    - Add support for PWM mode in mpc52xx_gpt.c that uses that PWM class
>>>    - And add an interface for the LED to use the PWM class
>>>
>>> 2) - Create an LED driver that accesses the mpc52xx_gpt directly.
>>>
>>> I think I would be overwhelmed trying to implement (1) but am confident
>>> to do (2). What do you think is the right approach?
>>
>> I'd suggest creating a generic PWM class, i.e. PWMLIB, alike to
>> GPIOLIB. (2) can be an acceptable approach for now, but for the
>> long-term solution (1) is the way to go.
>
> What happened to this one?
>
> http://ozlabs.org/pipermail/linuxppc-dev/2008-October/063562.html
>

Adding Bill to see if he has any updates.

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
