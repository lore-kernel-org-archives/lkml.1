Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbYGSKWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbYGSKWz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 06:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbYGSKWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 06:22:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:51418 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165AbYGSKWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 06:22:04 -0400
Message-ID: <487FEEAC.9040809@kernel.org>
Date: Fri, 18 Jul 2008 10:15:24 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Jonathan Steinert <hachi@kuiki.net>, linux-kernel@vger.kernel.org,
       Johannes Niess <linux@johannes-niess.de>, linux-usb@vger.kernel.org
Subject: Re: USB attached SATA disk idle spindown
References: <20080624045953.GA24600@miyako.sixapart.com> <4860B651.9090104@s5r6.in-berlin.de>
In-Reply-To: <4860B651.9090104@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 19 Jul 2008 10:21:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> (adding Cc: linux-usb and Johannes Niess)
> 
> On 6/24/2008 6:59 AM, Jonathan Steinert wrote at LKML:
>> Dear list,
>>
>> I am looking for what the current state of USB SATA timed spindown of-
>> disks is ata this time. I've been reading documents and mailing lists-
>> for every possible search I can dream up on the subject. Suggested-
>> workable solutions include (but are probably not limited to):
>>
>> $ hdparm -S
>>     This seems to be the ATA way of telling a disk to spin down, and it
>>     works in some situations, but doesn't appear to work on USB attached
>>     disks under 2.6.25
>>
>> $ sdparm
>>     This is suggested in a small number of locations. Most of which have
>>     examples on how to disable STANDBY on a handful of devices. I am
>>     unable to find any evidence that it can actually be used to enable
>>     power saving.
> 
> I think either of these depend on specific support by the USB to SATA
> bridge firmware.
> 
> I hear some newer bridges and their firmwares implement ATA
> pass-through.  Would that help?

Yeah, ATA pass through is all that's needed for hdparm -S to work.

-- 
tejun
