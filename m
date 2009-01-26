Return-Path: <linux-kernel-owner+w=401wt.eu-S1751768AbZAZJEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbZAZJEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 04:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750947AbZAZJEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 04:04:30 -0500
Received: from smtp.nokia.com ([192.100.122.233]:31268 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZAZJE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 04:04:29 -0500
Message-ID: <497D7F74.6050409@nokia.com>
Date: Mon, 26 Jan 2009 11:16:36 +0200
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: Add Extended CSD as a device attribute
References: <496E1187.60305@nokia.com>	<20090115160527.4cdbe94b.akpm@linux-foundation.org>	<4970646E.5020404@nokia.com> <20090124214543.60d7c939@mjolnir.drzeus.cx>
In-Reply-To: <20090124214543.60d7c939@mjolnir.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jan 2009 09:03:32.0608 (UTC) FILETIME=[F69C1000:01C97F94]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Fri, 16 Jan 2009 12:41:50 +0200
> Adrian Hunter <ext-adrian.hunter@nokia.com> wrote:
> 
>> From: Adrian Hunter <ext-adrian.hunter@nokia.com>
>> Date: Wed, 14 Jan 2009 17:45:53 +0200
>> Subject: [PATCH] MMC: Add Extended CSD as a device attribute
>>
>> Extended CSD is a MMC card register.  The Card Identification
>> (CID) register and the Card-Specific Data (CSD) register are
>> already device attributes.  As increasingly interesting
>> fields are being added to Extended CSD, it seems reasonable to
>> add it too.  Note that SD cards do not have an Extended CSD
>> register, so it is MMC only.
>>
>> Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
>> ---
> 
> Well, this might be interesting for debugging, but I don't see anything
> of general interest for user space in there. What's your use case?

Yes it is mainly just debugging.  It was done as a device attribute for
consistency with the other card registers CID and CSD.

Would you prefer #ifdef CONFIG_MMC_DEBUG or debugfs?
