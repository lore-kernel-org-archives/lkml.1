Return-Path: <linux-kernel-owner+w=401wt.eu-S1764616AbXHAKDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764616AbXHAKDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 06:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761232AbXHAKDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 06:03:46 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:39445 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759734AbXHAKDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 06:03:45 -0400
Message-ID: <46B059EB.7060003@gmail.com>
Date: Wed, 01 Aug 2007 12:01:15 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: kriko <kristjan.ugrin@gmail.com>
CC: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Reboot hang FIXED
References: <op.twci6be2atcbto@linux.site> <46AF9DC8.7080103@gmail.com> <op.twclwllkatcbto@linux.site> <46AFABE8.7050107@gmail.com> <op.twcmvlvcatcbto@linux.site> <46AFAF4E.1000605@gmail.com> <op.twcrsx1yatcbto@linux.site> <46B038B5.2030702@gmail.com> <op.twdgw4xiatcbto@linux.site> <46B04896.5020606@gmail.com> <op.twdjn41aatcbto@linux.site>
In-Reply-To: <op.twdjn41aatcbto@linux.site>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2007 11:37 AM, kriko wrote:

>>>  I just want to add that my DVD drive is not detected when using new 
>>> driver. So back to old one....
>>
>> You shouldn't have dropped Alan from CC then... pata_amd, right?
>>
>> Rene.
> 
> Sorry, yes its pata_amd.
> 
> IBM drive is on Primary master (detected as /dev/sdc)
> DVD-ROM is on Secondary master (not detected)

It's probably a timing issue (and might be related to why the old driver 
makes the BIOS hang at reboot) but pata_amd should I believe be one of the 
best tested pata drivers. Using it myself as well, on amd756. I haven't 
observed any problems with (a few) various CD/DVD drives attached and am not 
actually sure how to go about debugging the thing -- over to Alan.

The DVD-ROM is jumpered for master? Or for cable-select and using the master 
cable-slot? Using an 80-ribbon cable for it?

Rene.

