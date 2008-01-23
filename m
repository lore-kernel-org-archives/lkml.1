Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbYAWEZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbYAWEZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 23:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbYAWEZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 23:25:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49973 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbYAWEZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 23:25:20 -0500
Message-ID: <4796C0EF.6010600@zytor.com>
Date: Tue, 22 Jan 2008 20:22:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Fries <david@fries.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: W1: w1_slave units, standardize 1C or .001C?  Break API
References: <20080121231557.GA4025@spacedout.fries.net> <479541F5.9080705@zytor.com> <47955ECB.3050100@zytor.com> <20080123040937.GB4025@spacedout.fries.net>
In-Reply-To: <20080123040937.GB4025@spacedout.fries.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Fries wrote:
> On Mon, Jan 21, 2008 at 07:11:07PM -0800, H. Peter Anvin wrote:
>> H. Peter Anvin wrote:
>>> Millikelvins would have the nice property of never being negative.  :)
> 
> True, but the sensor returns the value as a signed integer in C.  That
> is where the earlier negative number problem was, it would have to do
> yet another conversion to go to Kelvin, and it would be just one more
> potential for error.  Everyone knows that a bad conversion doomed at
> least one space craft, let's stick to Centigrade.
> 

Uhm... the conversion is exact as long as you have at least centikelvin 
precision (0 °C = 273.15 K by definition, and the multiplier is 1.)

>> Alternatively, centikelvins would fit nicely in 16 bits if anyone cares...
>>
>> 655.35 K = 382.20 °C = 719.96 °F
> 
> The range for the sensor is -55 to 125 C, if an application didn't
> care about precision they could store it in a signed 8 bit value just
> fine.

This was more a comment as to it possibly being a convenient format for 
more than this particular sensor.

The nice thing with kelvins is no need to worry about negative numbers 
and something misparsing them, that's all.

I certainly did not imply that we should even consider use °F.  That's 
obviously ridiculous.

	-hpa

