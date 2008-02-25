Return-Path: <linux-kernel-owner+w=401wt.eu-S1761536AbYBYWef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761536AbYBYWef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761180AbYBYWeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:34:08 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53280 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760762AbYBYWeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:34:06 -0500
Date: Mon, 25 Feb 2008 23:34:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mark Lord <liml@rtr.ca>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       stern@rowland.harvard.edu, linux-ide@vger.kernel.org
Subject: Re: [ugly patch] Save .15W-.5W by AHCI powersaving
Message-ID: <20080225223432.GN2659@elf.ucw.cz>
References: <20080225134558.GA1611@elf.ucw.cz> <47C34081.5090205@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C34081.5090205@rtr.ca>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>> This is a patch (very ugly, assumes you have just one disk) to bring
>> powersaving to AHCI. You need Alan's SCSI autosuspend (attached) patch
>> as a base.
>>
>> It saves .5W compared to config with disk spinning, and even .15W
>> compared to hdparm -y... on my thinkpad x60 anyway.
> ..
>
> There was a discussion of this here today.

Real-life discussion, or something I could read? :-).

> It makes good use of AHCI-specific features.
>
> Has it been tested with a Port-Multiplier yet?

I do not know what port-multiplier is, sorry. But it was not really
tested. It is not expected to work on any other config than notebook
very similar to mine.

> This is cool enough that we really ought to do a hardware-independent
> version, so that all SATA interfaces could benefit.  Especially ata_piix,
> but others too.

Well, it seems like it is 10 lines per driver once Alan's SCSI
autosuspend patches are in...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
