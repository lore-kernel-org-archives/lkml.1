Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030243Ab0B0RWQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 12:22:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51272 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030198Ab0B0RWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 12:22:14 -0500
References: <cover.1267225701.git.gardner.ben@gmail.com> <201002262302.18890.david-b@pacbell.net> <20100227102609.GA2994@sirena.org.uk> <201002270824.14889.david-b@pacbell.net> (sfid-20100227_162422_584276_F9E21456)
Message-Id: <A6EC110C-1712-4AC7-B828-D7BB08278996@opensource.wolfsonmicro.com>
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Brownell <david-b@pacbell.net>
In-Reply-To: <201002270824.14889.david-b@pacbell.net> (sfid-20100227_162422_584276_F9E21456)
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPod Mail (7D11)
Mime-Version: 1.0 (iPod Mail 7D11)
Subject: Re: [PATCH 1/3] gpiolib: add gpio_set_direction()
Date: Sat, 27 Feb 2010 17:20:58 +0000
Cc: Ben Gardner <gardner.ben@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andres Salomon <dilinger@collabora.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 Feb 2010, at 16:24, David Brownell <david-b@pacbell.net> wrote:

> On Saturday 27 February 2010, Mark Brown wrote:
>>>  "none" ... since it's not even a GPIO, why would it show
>>>       up through the GPIO subsystem???
>>
>> I suspect this is intended to be tristated, which might be useful  
>> to add.
>
> That's what "input" means, as a rule:  no output driver
> is active with a GPIO configured as "iput".  "Tristate"
> is an option that's relevant for outputs ... low, high,
> or not-driven.

Indeed, but some devices do implement a distinct tristate state for  
input mode pins (disabling interrupt generation logic and so on for  
example).
