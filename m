Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbZEQIwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbZEQIwi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 04:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbZEQIw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 04:52:27 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:53412 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbZEQIwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 04:52:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MVtzipW9yHrpJwG5sYv1ODfKRnaM8bjiW3lEmq8UuY7osMwk5O4/3BPTi9GICN9UP/
         O6ob++5IPhcdcGdrELJ+XjWVBFAJU8zgYWha/9xPhP2KOdFVyjjRv2+x2V+C1AQXhL/y
         tC6oSGjcfQvHitPR3S07I40oyVwEtqcdjGJ9M=
Message-ID: <4A0FD045.5070208@gmail.com>
Date: Sun, 17 May 2009 02:52:21 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mark Knecht <markknecht@gmail.com>
CC: Satish Eerpini <eerpini@gmail.com>, Rik van Riel <riel@redhat.com>,
       Ray Lee <ray-lk@madrabbit.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: unresponsiveness on linux desktop during file copy
References: <93655eb70905151007v5f9bb34aj34be4b65ffeb02a4@mail.gmail.com>	 <5bdc1c8b0905151012x51c19b5cv639cadab1cee3849@mail.gmail.com>	 <93655eb70905151024o634f8432j6c3db85df1f6ddfc@mail.gmail.com>	 <5bdc1c8b0905151120p5aa58318t1765544fbbb695b2@mail.gmail.com>	 <93655eb70905151938y558bf86flcfb7c6b6b2c171c6@mail.gmail.com> <5bdc1c8b0905151947j326d31d9k5c7b1074af2b0bf0@mail.gmail.com>
In-Reply-To: <5bdc1c8b0905151947j326d31d9k5c7b1074af2b0bf0@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Knecht wrote:
> On Fri, May 15, 2009 at 7:38 PM, Satish Eerpini <eerpini@gmail.com> wrote:
> <SNIP>
>> yeah I get similar numbers even in the absence of the desktop manager
>> , when I tried to copy from  a virtual console.
>> the stats look something like this :
> <SNIP>
>> 00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family)
>> SATA IDE Controller (rev 01)
> <SNIP>
> 
> I googled on "82801GBM/GHM slow" and found a lot to read.
> 
> Is DMA for this drive enabled? It seems that some others didn't have
> it enabled by default, or maybe at all. I didn't real the threads very
> far.
> 
> hdparm -d1 /dev/sda
> 
> I think hdparm works for most SATA drivers. man sata to see the other
> things you can check in terms of configuration.

Switching on DMA manually isn't possible with libata through hdparm 
currently. However, this shouldn't be required with libata.

> 
> Clearly, since you see the same thing in a console with X never having
> been started says it's not a GUI issue.
> 
> Hope this helps,
> Mark

