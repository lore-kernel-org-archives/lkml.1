Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbZGUKeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbZGUKeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbZGUKen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:34:43 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:9281 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbZGUKem convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:34:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xTHq+rjRWaquom6rwdOttdml8FKmFdryKqvDFO6pasceXGJ5WI79R/LE5By0vNoIQo
         XEqltCR87m6Q5nItMiFCfVWFp3f/HpuQhpvSdg+0p9LBvNZin0ZoYrzPzfP07BfMJq8n
         GHxdwXb4pDkLkmaquJ/9ZA6Q1SmgBnGBT9eoU=
MIME-Version: 1.0
In-Reply-To: <20090721102153.GE4133@elf.ucw.cz>
References: <20090714100634.GA4054@elf.ucw.cz>
	 <5d5443650907140320w334864f4uc1ee13ed32fdb874@mail.gmail.com>
	 <20090715133627.GA2538@elf.ucw.cz>
	 <5d5443650907151033w36008b71pe4b32bcea9489b75@mail.gmail.com>
	 <20090721102153.GE4133@elf.ucw.cz>
Date: Tue, 21 Jul 2009 16:04:41 +0530
Message-ID: <5d5443650907210334k3f562cebsc665511a161c8639@mail.gmail.com>
Subject: Re: Support for synaptic touchscreen in HTC dream
From: Trilok Soni <soni.trilok@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Arve Hj?nnev?g" <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, dmitry.torokhov@gmail.com,
       dtor@mail.ru, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Tue, Jul 21, 2009 at 3:51 PM, Pavel Machek<pavel@ucw.cz> wrote:
> Hi!
>
>> >> disable_irq_nosync or convert this to request_threaded_irq(...).
>> >> Please see recent discussion on linux-input for MAX key switch
>> >> controller.
>> >
>> > Do you have a link? (I replaced it with disable_irq_nosync, if that is
>> > enough...)
>> >
>>
>> link: http://patchwork.kernel.org/patch/35515/
>
> Thanks!
>
>> >> > +       if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
>> >>
>> >> check for SMBUS? I have added linux-i2c as this driver has i2c bits,
>> >> so not removing any code.
>> >
>> > I guess this driver is only probed on mach-pxa... on machines that
>> > have the neccessary hardware.
>>
>> Because this driver is using smbus i2c apis, it will be good to add
>> that check too.
>
> So I should do something like
>
> if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_WORD_DATA))
>        ...
>
> in addition?

Yes.



-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
