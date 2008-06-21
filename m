Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633AbYFURAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbYFURAe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 13:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbYFURA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 13:00:26 -0400
Received: from rtr.ca ([76.10.145.34]:4633 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbYFURAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 13:00:25 -0400
Message-ID: <485D33A8.60200@rtr.ca>
Date: Sat, 21 Jun 2008 13:00:24 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: hdparm -M acoustic management for sata disks?
References: <1214043295.17302.16.camel@localhost>  <485D098E.3080109@rtr.ca> <1214066456.18959.6.camel@localhost> <485D3260.20301@rtr.ca>
In-Reply-To: <485D3260.20301@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
>..
> Here's hdparm-8.9 on a drive that *does* support the feature:
> 
> 
> $ hdparm -I /dev/sda | grep Acoustic
>           *    Automatic Acoustic Management feature set
> 
> $ hdparm -M /dev/sda
> 
> /dev/sda:
> acoustic      = 254 (128=quiet ... 254=fast)
> 
> $ hdparm -M128 /dev/sda
> 
> /dev/sda:
> setting acoustic management to 128
> acoustic      = 128 (128=quiet ... 254=fast)
> 
> $ hdparm -M254 /dev/sda
> 
> /dev/sda:
> setting acoustic management to 254
> acoustic      = 254 (128=quiet ... 254=fast)
..

And one more:

$ hdparm -M0 /dev/sda

/dev/sda:
 setting acoustic management to 0
 acoustic      = 254 (128=quiet ... 254=fast)

$ hdparm -I /dev/sda | grep -i acoustic
        Recommended acoustic management value: 128, current value: 254
                Automatic Acoustic Management feature set

(the lack of a '*' on that last line indicates the feature is no longer enabled).

-ml
