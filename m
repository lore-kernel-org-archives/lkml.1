Return-Path: <linux-kernel-owner+w=401wt.eu-S1765690AbYBZVsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765690AbYBZVsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763145AbYBZVsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:48:43 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33904 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762868AbYBZVsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:48:42 -0500
Date: Tue, 26 Feb 2008 22:49:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mark Lord <lkml@rtr.ca>
Cc: Mark Lord <liml@rtr.ca>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       stern@rowland.harvard.edu, linux-ide@vger.kernel.org
Subject: Re: [ugly patch] Save .15W-.5W by AHCI powersaving
Message-ID: <20080226214908.GC10280@elf.ucw.cz>
References: <20080225134558.GA1611@elf.ucw.cz> <47C34081.5090205@rtr.ca> <20080225223432.GN2659@elf.ucw.cz> <47C435C4.9000402@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C435C4.9000402@rtr.ca>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-02-26 10:52:36, Mark Lord wrote:
> Pavel Machek wrote:
>> Hi!
>>
>>>> This is a patch (very ugly, assumes you have just one disk) to bring
>>>> powersaving to AHCI. You need Alan's SCSI autosuspend (attached) patch
>>>> as a base.
>>>>
>>>> It saves .5W compared to config with disk spinning, and even .15W
>>>> compared to hdparm -y... on my thinkpad x60 anyway.
>>> ..
>>>
>>> There was a discussion of this here today.
>>
>> Real-life discussion, or something I could read? :-).
>>
>>> It makes good use of AHCI-specific features.
>>>
>>> Has it been tested with a Port-Multiplier yet?
>>
>> I do not know what port-multiplier is, sorry. But it was not really
>> tested. It is not expected to work on any other config than notebook
>> very similar to mine.
>>
>>> This is cool enough that we really ought to do a hardware-independent
>>> version, so that all SATA interfaces could benefit.  Especially ata_piix,
>>> but others too.
>>
>> Well, it seems like it is 10 lines per driver once Alan's SCSI
>> autosuspend patches are in...
> ..
>
> Cool (literally)!
>
> I think I might have gotten your patch confused in my mind
> with another AHCI patch, which uses features of the chip itself
> to automatically negotiate/change link power status on the fly
> (no s/w needed, other than to turn it on).
>
> That one is very ACPI specific, though.

Yep, I seen that, too. I'm just afraid to check, maybe AHCI powerdown
does not save that much power when links in powersave already...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
