Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbZKVPo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbZKVPo6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 10:44:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbZKVPo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 10:44:58 -0500
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:52379 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835AbZKVPo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 10:44:57 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B095CA4.9080406@cam.ac.uk>
Date: Sun, 22 Nov 2009 15:45:40 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20091029)
MIME-Version: 1.0
To: Amit Kucheria <amit.kucheria@verdurent.com>
CC: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] Staging: IIO: Add tsl2560-2 support to tsl2563 driver
 + 	drop tsl2561, driver.
References: <4B06EA3B.10500@cam.ac.uk> <37786d4b0911201214g65ea0f8fke1ac29b326fffe47@mail.gmail.com>
In-Reply-To: <37786d4b0911201214g65ea0f8fke1ac29b326fffe47@mail.gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Kucheria wrote:
> On Fri, Nov 20, 2009 at 9:12 PM, Jonathan Cameron <jic23@cam.ac.uk> wrote:
>> These parts (tsl2560-tsl2563) are identical in interface.
>> The tsl2563 driver is more advanced so makes sense to drop
>> the tsl2561 driver.
>>
>> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
>> ---
>> Greg, I've done the changes and driver removal as a single patch.
>> Can separate into two if you would prefer?
>>
>> Amit, as promised I have tested against the tsl2561 on an imote2
>> sensor board (for which the original driver was written). All seems
>> to work as intended.  Only changes are addition of devices to the
>> device table and Kconfig comment changes to reflect new support.
>> Hope you don't mind, but I dropped the N900 reference.  These things
>> are pretty common (including the new parts) and we don't really
>> want to encourage people to start listing where they found. I
>> haven't done any of the other changes I suggested, but can do
>> those as a follow up patch if you don't mind?
>>
>> There are a few more similar chips with slightly different conversion
>> functions.
>>
>> Thanks,
>>
>> Jonathan
> 
> Jonathan,
> 
> Changes looks good. I'll send my acks on the split up patches.
Cool, I'll do them in a few mins.
> 
> I'm working on moving this driver to the input subsystem as agreed.
Input?  Ambient Light sensors subsystem makes sense. Input certainly 
does not (and will get copious NAKs). I was beginning to doubt that ALS
will get sorted out in time for the next merge window (or that the
various drivers would get moved across in time), hence this patch to
clear up a bit of a mess and a lot of pointless code in IIO as Greg has
already taken your driver into the staging tree.
> I
> was planning to address your review comments in that rework. I can
> defer that work if you want.
Sure, that's fine with me, though given the wonders of staging, you may
well find a 3rd party submits patches for your driver in the meantime ;)

Thanks,

Jonathan

