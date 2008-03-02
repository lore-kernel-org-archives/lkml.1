Return-Path: <linux-kernel-owner+w=401wt.eu-S1758862AbYCBUqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862AbYCBUqP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 15:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYCBUqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 15:46:00 -0500
Received: from mailout05.sul.t-online.de ([194.25.134.82]:40310 "EHLO
	mailout05.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753917AbYCBUp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 15:45:59 -0500
Message-ID: <47CB11FA.60008@t-online.de>
Date: Sun, 02 Mar 2008 21:45:46 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mike@Keehan.net, linux-kernel@vger.kernel.org
Subject: Re: strange behavior on multimedia eject button for cdrom
References: <47C15020.8040806@t-online.de> <47C7FECD.3040205@Keehan.net>
In-Reply-To: <47C7FECD.3040205@Keehan.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: VmtlTiZvrh1Cqifgolp01gqn0YySUEo4f+Ukjh-byQi1fP4fGsJxTDKEOYZsTqww0Y
X-TOI-MSGID: 9e347a2b-79f8-41f2-b029-a69af788e8b9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Mike Keehan wrote:
> Hi Harold.
> 
> Somewhere on the web I read that some of the M1330 media keys are 
> directly connected to the drive, hence the lack of keycodes.
> 
> If you eject a disk while it is being played, then the Linux driver will 
> get a read failure.  What happens then may not be well defined :)
> 

Maybe there is some misunderstanding here: I am not playing music
from the CD. It is idle. But if I press the CD eject button, then
audio output (e.g. some mp3 file played from harddisk) gets
corrupted, the network connection is dead, etc.

Ejecting the CD takes about 7 seconds. Durig this time Linux is
dead! I haven't checked any SCHED_FIFO or SCHED_RR applications,
but AFAIK this shouldn't happen.

If I run "eject cdrom" on the console instead, then there is no
such problem.


Regards

Harri

