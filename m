Return-Path: <linux-kernel-owner+w=401wt.eu-S1760161AbYCCUPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760161AbYCCUPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 15:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbYCCUPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 15:15:07 -0500
Received: from smtp-out2.blueyonder.co.uk ([195.188.213.5]:54986 "EHLO
	smtp-out2.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750850AbYCCUPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 15:15:06 -0500
Message-ID: <47CC5C47.8050604@Keehan.net>
Date: Mon, 03 Mar 2008 20:15:03 +0000
From: Mike Keehan <Mike@Keehan.net>
Reply-To: Mike@Keehan.net
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Harald Dunkel <harald.dunkel@t-online.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: strange behavior on multimedia eject button for cdrom
References: <47C15020.8040806@t-online.de> <47C7FECD.3040205@Keehan.net> <47CB11FA.60008@t-online.de>
In-Reply-To: <47CB11FA.60008@t-online.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harald Dunkel wrote:
> Hi Mike,
> 
> Mike Keehan wrote:
>> Hi Harold.
>>
>> Somewhere on the web I read that some of the M1330 media keys are 
>> directly connected to the drive, hence the lack of keycodes.
>>
>> If you eject a disk while it is being played, then the Linux driver 
>> will get a read failure.  What happens then may not be well defined :)
>>
> 
> Maybe there is some misunderstanding here: I am not playing music
> from the CD. It is idle. But if I press the CD eject button, then
> audio output (e.g. some mp3 file played from harddisk) gets
> corrupted, the network connection is dead, etc.
> 
> Ejecting the CD takes about 7 seconds. Durig this time Linux is
> dead! I haven't checked any SCHED_FIFO or SCHED_RR applications,
> but AFAIK this shouldn't happen.
> 
> If I run "eject cdrom" on the console instead, then there is no
> such problem.
> 
> 
> Regards
> 
> Harri
> 

Hi again.

Ok, I just tried doing the same thing on my M1330.  It behaves 
differently to yours in that a small section of music repeats again 
and again until the disk is ejected, and then carries on (I was using 
RealPlayer with a local file as a simple test).

And it does look like other things stop working while the disk is 
ejected - screen updates freeze and network too I think.

I'm going to be travelling for the next few days, so I won't be able 
to try anything else till later in the week.

Regards,

    Mike.



