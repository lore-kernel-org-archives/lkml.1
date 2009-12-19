Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbZLSULQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbZLSULQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 15:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbZLSULP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 15:11:15 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:64410 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbZLSULO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 15:11:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bB3xJK5w7opQ9a5ybEQa4XbdPz8lgLeFdeXfAzWygalK1SvYuRjeTa5/ivBqdQ9MWY
         ZZ/G+8gaAdLlaejP/6Dc8Cij0GufT3GS2znmY9wQZjJyxkMXZ+Z4SMjdulImdd3XhV86
         YzYr+pQoSiDhjSfHlVK7FxVdP1bW+cQhz8EPQ=
Message-ID: <4B2D335F.6050705@garzik.org>
Date: Sat, 19 Dec 2009 15:11:11 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       saeed bishara <saeed.bishara@gmail.com>
Subject: Re: [git patches] libata updates
References: <20091219181350.GA21058@havoc.gtf.org> <alpine.LFD.2.00.0912191102320.3712@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912191102320.3712@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2009 02:05 PM, Linus Torvalds wrote:
> On Sat, 19 Dec 2009, Jeff Garzik wrote:
>>
>> to receive the following updates:
>>
>>   drivers/ata/libata-scsi.c    |    2 +-
>>   drivers/ata/libata-sff.c     |    2 +-
>>   drivers/ata/pata_hpt3x2n.c   |   64 ++++++++++---------
>>   drivers/ata/pata_octeon_cf.c |    2 +-
>>   drivers/ata/sata_mv.c        |  144 ++++++++++++++++++++++++++++++++++++------
>>   5 files changed, 163 insertions(+), 51 deletions(-)
>>   mode change 100644 =>  100755 drivers/ata/sata_mv.c
>
> WTF is that mode change?
>
> It's introduced by commit 6481f2b52cd5411ea6342b749daf0e4f3b390d7b:
> "sata_mv: add power management support for the platform driver", and it's
> totally nonsensical.
>
> I fixed that crazy stuff when merging, but you should look at your own
> summaries a bit, and should have noticed that it was crazy. That file
> isn't an executable.

Whoops, you're absolutely right.  That's broken.

	Jeff



