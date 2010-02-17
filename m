Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab0BQU5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 15:57:17 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:54573 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab0BQU5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 15:57:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=Ius3NmFj77z1kkpKjcVysMKakoQjqayoTCb6QMCb9RYuLqBqyzKQ6hbJ7CqJN5gi/9
         d8rNdoZv/S5TDf3cy1T2dToEhIWnGbkazeE+oMELqJuoIDwqPQdanuEoCTqLTxBGDaix
         wBcIXUo1/WXBZk0xRTrt2mHW/Z8n70lm1fHxY=
References: <20100217163751.030764372@linutronix.de> <20100217165741.GA5504@linux-mips.org>
Message-Id: <3310E995-FF29-4537-84CC-A15BA09F3DE9@gmail.com>
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
In-Reply-To: <20100217165741.GA5504@linux-mips.org>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7C144)
Mime-Version: 1.0 (iPhone Mail 7C144)
Subject: Re: [patch] i8253: Convert i8253_lock to raw_spinlock
Date: Wed, 17 Feb 2010 12:56:58 -0800
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       x86 team <x86@kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 17, 2010, at 8:57 AM, Ralf Baechle <ralf@linux-mips.org> wrote:

> On Wed, Feb 17, 2010 at 04:47:10PM -0000, Thomas Gleixner wrote:
>
>> i8253_lock needs to be a real spinlock in preempt-rt, i.e. it can
>> not be converted to a sleeping lock.
>>
>> Convert it to raw_spinlock and fix up all users.
>>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ralf Baechle <ralf@linux-mips.org>
>> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>> Cc: Takashi Iwai <tiwai@suse.de>
>> Cc: Jens Axboe <jens.axboe@oracle.com>
>
> Acked-by: Ralf Baechle <ralf@linux-mips.org>

Acked-by: Dmitry Torokhov <dtor@mail.ru>

