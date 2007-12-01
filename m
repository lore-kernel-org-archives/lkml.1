Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbXLAMXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbXLAMXz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 07:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbXLAMXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 07:23:43 -0500
Received: from lucidpixels.com ([75.144.35.66]:36226 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239AbXLAMXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 07:23:42 -0500
Date: Sat, 1 Dec 2007 07:23:41 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-ide@vger.kernel.org, apiszcz@solarrain.com
Subject: Re: Kernel 2.6.23.9 / P35 Chipset + WD 750GB Drives (reset port)
In-Reply-To: <Pine.LNX.4.64.0712011310410.30316@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0712010722590.28887@p34.internal.lan>
References: <Pine.LNX.4.64.0712010619150.25643@p34.internal.lan>
 <Pine.LNX.4.64.0712011310410.30316@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 1 Dec 2007, Jan Engelhardt wrote:

>
> On Dec 1 2007 06:26, Justin Piszcz wrote:
>> I ran the following:
>>
>> dd if=/dev/zero of=/dev/sdc
>> dd if=/dev/zero of=/dev/sdd
>> dd if=/dev/zero of=/dev/sde
>>
>> (as it is always a very good idea to do this with any new disk)
>
> Why would you care about what's on the disk? fdisk, mkfs and
> the day-to-day operation will overwrite it _anyway_.
>
> (If you think the disk is not empty, you should look at it
> and copy off all usable warez beforehand :-)
>

The purpose is with any new disk its good to write to all the blocks and 
let the drive to all of the re-mapping before you put 'real' data on it. 
Let it crap out or fail before I put my data on it.

Justin.
