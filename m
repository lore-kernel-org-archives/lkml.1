Return-Path: <linux-kernel-owner+w=401wt.eu-S1759319AbYENOXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbYENOXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 10:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755544AbYENOXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 10:23:42 -0400
Received: from adnil.foobar.fi ([81.17.206.99]:44777 "EHLO ikijono.foobar.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755542AbYENOXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 10:23:41 -0400
Message-ID: <482AF5E7.9070801@bluegiga.com>
Date: Wed, 14 May 2008 17:23:35 +0300
From: "Kim B. Heino" <Kim.Heino@bluegiga.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20080501)
MIME-Version: 1.0
To: rtc-linux@googlegroups.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] Re: [PATCH] add support for ST M41T94 SPI RTC
References: <482AD8D9.4090805@bluegiga.com> <20080514150820.7eb523c6@i1501.lan.towertech.it>
In-Reply-To: <20080514150820.7eb523c6@i1501.lan.towertech.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alessandro,

>  can you check that you really require
>  all of those #includes ?

You're right, I don't. Fixed.

>> +struct m41t94 {
>> +	struct rtc_device *rtc;
>> +	u8 buf[8]; /* Burst read cmd + 7 registers */
>> +};
>  why are you keeping the buffer here?

rtc-max6902.c did that too... Fixed.

>  the choice is up to you, but I'd use the century bit if there
>  is one.

Ok, I'll add support for century bit. Again there are some other 
rtc-drivers (like rtc-m41t80.c and rtc-ds1307.c) not using it.

>  no spaces between MODULE_XXX and the ( please.

Fixed.

I'll wait for more comments and post a new patch tomorrow.
