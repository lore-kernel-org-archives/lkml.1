Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbZFCEKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbZFCEKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 00:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbZFCEKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 00:10:31 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:36135 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbZFCEKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 00:10:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LPQfL5hXemBzhjoTmk+J32dNMm4OBNTz6zu9aEkfkAqaMqbpB2/wXngGWXu3hFlvfJ
         6b5P754yOWYRHQVgQerwSqWIFdZcz3p5mHZzrkWOrucQYd73MOmV7X+KIzQGQqDZOzvY
         09pzlLZiswiKckxldA9gesbGB9CDsm+fm0E+8=
Message-ID: <4A25F7B6.4080904@gmail.com>
Date: Tue, 02 Jun 2009 22:10:30 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Markus <M4rkusXXL@web.de>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Seagate Barracuda 7200.11 ST31500341AS fw SD17
References: <200906021258.20346.M4rkusXXL@web.de>
In-Reply-To: <200906021258.20346.M4rkusXXL@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus wrote:
> Hello!
> 
> I have some Seagate Barracuda 7200.11 ST31500341AS 1.5TB drives. They 
> use the firmware SD17.
> They time out at the flush write cache and sometimes on the identify 
> command.
> I know that sounds suspicious so I wrote to seagate but they told me my 
> drives are ok. (Although I dont think so.)
> 
> This drive+fw is blacklisted in the kernel, but there is no firmware 
> upgrade for these drives. (Only very few serial numbers are able to 
> upgrade.)
> 
> Now I want to know after what period of the time the kernel timeouts at 
> these commands!? And if this timeout can be increased (manually, small 
> patch for the kernel) and the min/max/avg time could somehow be 
> messured. Every timeout kicks the drives off the raid, so I disabled 
> the write cache (hdparm -W0 /dev/sdx) but thats no solution, just a bad 
> workaround.

I believe the timeout for commands like these is usually 30 seconds. 
Normally if it doesn't respond after that length of time, it never will. 
Even if it eventually did, I don't think you'd be happy with disk access 
delays of over 30 seconds..

> 
> Its a amd64 system with the 2.6.29.4 on an AM3 board with AMDs 790GX + 
> SB750 Chipsets running in ahci mode.
> 
> Thanks for your time and support!
> 
> Markus
> 
> PS: Please CC me!

