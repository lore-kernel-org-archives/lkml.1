Return-Path: <linux-kernel-owner+w=401wt.eu-S1752626AbXA3A1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbXA3A1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 19:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbXA3A1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 19:27:22 -0500
Received: from terminus.zytor.com ([192.83.249.54]:55303 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbXA3A1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 19:27:21 -0500
Message-ID: <45BE90D4.1030506@zytor.com>
Date: Mon, 29 Jan 2007 16:27:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Kevin Nicoll <blort128@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Multiple ip= boot arguments?
References: <e4fa6c610701291036r7ff384e4u78d3995ab3d042d8@mail.gmail.com> <Pine.LNX.4.61.0701292146470.5077@yvahk01.tjqt.qr> <45BE8AAA.9020308@zytor.com> <45BE9043.5020508@nortel.com>
In-Reply-To: <45BE9043.5020508@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> H. Peter Anvin wrote:
>> Jan Engelhardt wrote:
>>>
>>>> or if I'm supposed to use a startup script instead.
>>>
>>> This is the preffered way nowadays. One day, hopefully,
>>> CONFIG_IP_PNP can go away.
>>>
>> It could be done reasonably easy, you know... :-/
> 
> If CONFIG_IP_PNP is going to go away, what is the proposed mechanism for 
> netboot devices to determine the proper source address to use when 
> searching for a rootfs to use?

My quip was mostly that it could replaced with the existing klibc 
implementation, which runs in userspace.

The other option, of course, is the distribution-specific initramfs route.

	-hpa
