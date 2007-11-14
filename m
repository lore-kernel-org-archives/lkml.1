Return-Path: <linux-kernel-owner+w=401wt.eu-S1760196AbXKNQ0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196AbXKNQ0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 11:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbXKNQ0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 11:26:08 -0500
Received: from rtr.ca ([76.10.145.34]:1607 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722AbXKNQ0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 11:26:07 -0500
Message-ID: <473B219E.5060508@rtr.ca>
Date: Wed, 14 Nov 2007 11:26:06 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Sebastian Kemper <sebastian_ml@gmx.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: libata/PATA: GPCMD_SET_STREAMING via SG_IO does nothing
References: <20071113164323.GA5252@section-eight> <20071113212230.77cadecd@the-village.bc.nu> <20071113232859.GA4681@section-eight>
In-Reply-To: <20071113232859.GA4681@section-eight>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Kemper wrote:
> Hi Alan!
> 
> On Tue, Nov 13, 2007 at 09:22:30PM +0000, Alan Cox wrote:
>> It isn't a known issue, and it suprises me as SG_IO basically passes
>> commands through to the drive. We don't support speed change via xfermode
>> setting but GPCMD_SET_STREAMING sohuld behave.
>>
>> Do you have a simple code example that shows the problem ?
> 
> http://svn.mplayerhq.hu/mplayer/trunk/stream/stream_dvd.c?view=markup
..

That code is riddled with bugs, by the way.
It fails to close/clean-up on just about every exit path.
But apart from that, it does appear to issue the command.

Another way to the same thing is with "hdparm -E",
which contrary to my earlier posting actually does
seem to work already with libata.

> See dvd_set_speed(). The drive I'm using is an Optiarc DVD RW AD-7170A.
> With the "old" ATA driver dvd_set_speed() works, with libata it doesn't.
..

Can you define "doesn't work" for me?
How can I test this to see if it works one way or another ?

The command issue (ioctl) is not returning -1.

