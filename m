Return-Path: <linux-kernel-owner+w=401wt.eu-S967353AbXG3ScY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967353AbXG3ScY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 14:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934097AbXG3ScQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 14:32:16 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:37155 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762655AbXG3ScP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 14:32:15 -0400
Message-ID: <46AE2E1E.6050909@gmail.com>
Date: Mon, 30 Jul 2007 20:29:50 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Phillip Susi <psusi@cfl.rr.com>
CC: Lindsay Roberts <lindsay.roberts.os@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs: Add romfs version 2
References: <8734b7880707122301m400294d4nf12072f949c95fa4@mail.gmail.com> <46AE2A23.9060204@cfl.rr.com>
In-Reply-To: <46AE2A23.9060204@cfl.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2007 08:12 PM, Phillip Susi wrote:

> Lindsay Roberts wrote:
>> * Increases romfs partition size limit from 2GB to 4GB.
>> * Adds new derivative of romfs filesystem (rom2fs) with
>>  block aligned regular file data to bring performance
>>  parity with ext2/3. This is about 225% of the read
>>  speed of the existing romfs.
> 
> Why does block alignment of files have any influence on speed for a rom 
> based ( no seek time ) filesystem?

A CD-ROM is also a ROM...

But on a general note, please also note that the expensive seek versus cheap 
read we know from magnetic is (well, can be that is) still present with 
memory technologies, although much less pronounced.

Memory technologies (including flash) have historically had "burst" modes 
where sequential accesses are sped up significanly versus random accesses, 
causing really the exact same seek-versus-read principle as on magnetic.

Quite uncertain if/when the difference will ever be as pronounced as on 
magnetic, but I believe we should at least be prepared to deal with this 
problem for a _long_ time still...

Rene.

