Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996AbZK2V3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbZK2V3r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 16:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbZK2V3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 16:29:46 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:42397 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbZK2V3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 16:29:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=veRIhfiSE2D6N1geWQB95xw887rbtSS5s3eemOQhnYr8THuWjn1kFHbiH5Zogzkk36
         rm4gyRZLFU4HvzpsVW5odVH8wj7RMQxCszjbTqWJylNTRMfVgks+opDzBhPxVhFUSUGn
         636nx08mvj2NbWKKsLUEB7oamx6wqgpYtUo9s=
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc> <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com> <m3aay6y2m1.fsf@intrepid.localdomain> <9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com> <1259450815.3137.19.camel@palomino.walls.org> <m3ocml6ppt.fsf@intrepid.localdomain> <9e4733910911291244p364b328fm3a76ded4e4cd8603@mail.gmail.com>
Message-Id: <83224BA3-A5FF-4525-BF20-16A60F865C0A@gmail.com>
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jon Smirl <jonsmirl@gmail.com>
In-Reply-To: <9e4733910911291244p364b328fm3a76ded4e4cd8603@mail.gmail.com>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7C144)
Mime-Version: 1.0 (iPhone Mail 7C144)
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
Date: Sun, 29 Nov 2009 13:29:37 -0800
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Andy Walls <awalls@radix.net>,
       Christoph Bartelmus <lirc@bartelmus.de>, "j@jannau.net" <j@jannau.net>,
       "jarod@redhat.com" <jarod@redhat.com>,
       "jarod@wilsonet.com" <jarod@wilsonet.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
       "maximlevitsky@gmail.com" <maximlevitsky@gmail.com>,
       "mchehab@redhat.com" <mchehab@redhat.com>,
       "stefanr@s5r6.in-berlin.de" <stefanr@s5r6.in-berlin.de>,
       "superm1@ubuntu.com" <superm1@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 29, 2009, at 12:44 PM, Jon Smirl <jonsmirl@gmail.com> wrote:

> On Sun, Nov 29, 2009 at 3:27 PM, Krzysztof Halasa <khc@pm.waw.pl>  
> wrote:
>> 1. Do we agree that a lirc (-style) kernel-user interface is needed  
>> at
>>   least?
>>
>> 2. Is there any problem with lirc kernel-user interface?
>
> Can you consider sending the raw IR data as a new evdev message type
> instead of creating a new device protocol?

No, I think it would be wrong. Such events are ill-suited for  
consumption by regular applications and would introduce the "looping"  
interface I described in my other email.

> evdev protects the messages in a transaction to stop incomplete
> messages from being read.

If such property is desired we can add it to the new lirc-like  
interface, can't we?

-- 
>
Dmitry
