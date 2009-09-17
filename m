Return-Path: <linux-kernel-owner+w=401wt.eu-S1757099AbZIQNzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099AbZIQNzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 09:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbZIQNzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 09:55:31 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:31404 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbZIQNza convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 09:55:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=WGDtqlkxg/xaKPX3alAJ2Y4EEhMxwFMBELuWxf/KeWnBL/HvPCb9MJo39nkreuKiWY
         USLw6J/opmSFIS6H8gQiToMcHnHlvSzxD17Iq7I14J+Yq37f0oopIjQPWXwLnOtAVODC
         txne5T2y3pv64LDcGFrNcnQ0B0DJvfrAa7RRk=
MIME-Version: 1.0
Date: Thu, 17 Sep 2009 09:55:33 -0400
X-Google-Sender-Auth: 33cf5a90bb070ae6
Message-ID: <37219a840909170655m46e64322ga189d3dd9599e195@mail.gmail.com>
Subject: [RESUBMIT PULL] http://kernellabs.com/hg/~mkrufky/saa7164
From: Michael Krufky <mkrufky@kernellabs.com>
To: Steven Toth <stoth@kernellabs.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 9:36 AM, Steven Toth <stoth@kernellabs.com> wrote:
> On 9/17/09 9:02 AM, Mauro Carvalho Chehab wrote:
>>
>> Em Thu, 03 Sep 2009 23:35:29 -0400
>> Steven Toth<stoth@kernellabs.com>  escreveu:
>>
>>> Hello Mauro,
>>>
>>> This patch series adds support for the NXP SAA7164 PCIe A/V bridge used
>>> by the
>>> Hauppauge HVR-2200 and HVR-2250 series of products. Support is limited to
>>> DVB-T
>>> / ATSC / QAM digital TV only. The driver has been in development (on and
>>> off)
>>> for around a year and the KernelLabs saa7164-stable tree (from which this
>>> patch
>>> set was prepared) has been in testing worldwide since approx May(?) 2009.
>>>
>>> The project page including links for firmware downloads, MythTV and Wiki
>>> instructions is here: http://www.kernellabs.com/blog/?page_id=17
>>>
>>> Two general observations with the tree:
>>>
>>> 1. The driver is a little verbose during initial module load, I need to
>>> trim a
>>> few lines of debug.
>>> 2. During 64bit compile I have one compile time warning to be addressed.
>>>
>>> Both of these will be resolved shortly and should not stop the driver
>>> being
>>> merged and made available to a much wider range of testers.
>>>
>>> So, please pull from http://www.kernellabs.com/hg/~stoth/saa7164-merge
>>
>>> SAA7164: Fix i2c eeprom read errors during load (some boards).
>>> From: Steven Toth<stoth@kernellabs.com>
>>> SAA7164: Fix i2c eeprom read errors during load (some boards).
>>> Priority: normal
>>> Signed-off-by: Steven Toth<stoth@kernellabs.com>
>>
>> Please don't repeat the one-line summary as description. There are several
>> cases like the above.
>>
>>>     -  Add the SAA7164 I2C bus identifier
>>
>> --- a/linux/include/linux/i2c-id.h      Thu Sep 03 09:06:34 2009 -0300
>> +++ b/linux/include/linux/i2c-id.h      Sat May 09 12:24:12 2009 -0400
>>
>> +#define I2C_HW_B_SAA7164        0x010024 /* NXP 7164 based tv cards */
>>
>> Why? Are you needing to use this constant somewhere? If not, just drop it
>> and
>> leave the field in blank.
>>
>> Anyway, I won't delay applying it due to that. I'm committing the series.
>> Please send a fix
>> later for the i2c-id above mentioned.
>
> Thanks.
>
> I should go back and check the other trees, if this field isn't required by
> the i2c sub-system then I can remove it from a number of drivers. Of course,
> this tree is fairly old and it may have already been done in the 23885 /
> cx88 / au0828 tree's by the other devs. I'll look into this.
>
> Regardless, I'll generate the i2c patch.
>
> I also have another 2.6.31 related patch stacked up, once mkrufky's tree is
> also merged. I'll issue both of these for merge later today.
>
> Thanks again,
>
> --
> Steven Toth - Kernel Labs
> http://www.kernellabs.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


Just to clarify, Steve is depending on the merge of some fixes in my
saa7164 tree before he proceeds.  Apologies if you're already looking
at this, but it doesn't hurt to point it out again just in case :-)  I
sent the pull request in the middle of Steve's thread, so it's
possible that it might have been overlooked.

Please note -- after merging Steve's tree, there are a few minor bugs
with the build / commit system that my tree repairs.

Please pull from:

http://kernellabs.com/hg/~mkrufky/saa7164

for the following fixes:

- make v4l/scripts/saa7164.pl executable
- saa7164: fix Kconfig: rename DVB_FE_CUSTOMIZE to MEDIA_TUNER_CUSTOMISE
- saa7164: fix Kconfig: remove HOTPLUG dependency
- enable VIDEO_SAA7164 for 2.6.24 and later
- saa7164: fix 64bit build warning

 linux/drivers/media/video/saa7164/Kconfig        |    3 +--
 linux/drivers/media/video/saa7164/saa7164-core.c |    2 +-
 v4l/versions.txt                                 |    2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

Thanks again to Steve for the long and hard work spent on this saa7164 driver.

Cheers,

Mike Krufky
