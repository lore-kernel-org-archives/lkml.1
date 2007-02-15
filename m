Return-Path: <linux-kernel-owner+w=401wt.eu-S932805AbXBOOTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805AbXBOOTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 09:19:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932807AbXBOOTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 09:19:05 -0500
Received: from terminus.zytor.com ([192.83.249.54]:36775 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932805AbXBOOTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 09:19:04 -0500
Message-ID: <45D46D3C.3010407@zytor.com>
Date: Thu, 15 Feb 2007 06:25:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dax Kelson <dax@gurulabs.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: Linus' laptop and Num lock status
References: <1171479361.3706.48.camel@mentorng.gurulabs.com> <Pine.LNX.4.64.0702141104210.3604@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702141104210.3604@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 14 Feb 2007, Dax Kelson wrote:
>> Are there any technical or political reasons why kernel can't change
>> from "force off" to "Follow BIOS"?
> 
> How would you query it? I'm not even 100% sure that you can on all 
> keyboards. We never query the leds, we always set them. I think. I don't 
> know of any AT kbd command to read the led state out of the keyboard.
> 

You can query the state of the keyboard according to BIOS by looking in 
byte 0x417 absolute, or by issuing int 0x16, ah = 0x02 (or ah = 0x12) 
from real mode.

	-hpa

