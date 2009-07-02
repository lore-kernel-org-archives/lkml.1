Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbZGBN4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbZGBN4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 09:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbZGBN4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 09:56:34 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:55865 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbZGBN4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 09:56:34 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4A4CBC5B.6040103@cam.ac.uk>
Date: Thu, 02 Jul 2009 13:55:39 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Chris Verges <chrisv@cyberswitching.com>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH] adxl345 accelerometer hwmon driver
References: <68FBE0F3CE97264395875AC1C468F22C152BE8@mail03.cyberswitching.local>	<4A4BB4AB.7010003@cam.ac.uk>	<68FBE0F3CE97264395875AC1C468F22C152BFA@mail03.cyberswitching.local>	<20090701221310.1d6aa587@hyperion.delvare>	<68FBE0F3CE97264395875AC1C468F22C152C1D@mail03.cyberswitching.local> <20090702132520.2e02959e@hyperion.delvare>
In-Reply-To: <20090702132520.2e02959e@hyperion.delvare>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> Hi Chris,
> 
> On Wed, 1 Jul 2009 13:52:28 -0700, Chris Verges wrote:
>>> Probably it's about time to put an end to this and kick all
>>> accelerometer drivers out of drivers/hwmon.
>> Hi Jean,
>>
>> This actually makes a lot of sense.  The remaining question is,
>> "To where do we kick them?"
>>
>> After reading Jonathan's iio.pdf, I'm all on-board with the
>> adxl345 driver being placed in this new subsystem.  However,
>> IIO subsystem isn't released into the "vanilla" kernel yet.
>>
>> Until the IIO subsystem is finished and I can port the driver
>> into it, what's the appropriate place for the adxl345 to
>> reside?  misc?  A new directory?
> 
> This is a very valid question, and the current situation probably is
> the result of it not having a simple answer.
> 
> We could create drivers/accelerometer and move the drivers there for
> the time being. Or we can move them to drivers/misc until iio is
> merged. Honestly, it would be great if iio could be finally merged, it
> would help driver authors get their driver in good shape and in the
> right place right away. But I know Jonathan is busy and I can't blame
> him if things take time.
Just for info, the latest version went to lkml about a minute ago. So now
it's over to other people finding the time to review / comment. (and me
to reply / implement their suggestions).

Thanks,

Jonathan
