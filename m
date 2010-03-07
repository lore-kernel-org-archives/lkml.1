Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab0CGHUK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 02:20:10 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59509 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab0CGHUI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 02:20:08 -0500
MIME-Version: 1.0
In-Reply-To: <20100307180744.956998c5.sfr@canb.auug.org.au>
References: <20100307064111.1442.63478.stgit@angua> <20100307180744.956998c5.sfr@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 7 Mar 2010 00:19:47 -0700
X-Google-Sender-Auth: 23c2d053d18aafc2
Message-ID: <fa686aa41003062319t33227670x1f0616cff887733b@mail.gmail.com>
Subject: Re: [RFC] drivercore: Add of_match_table to the common device drivers
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
       kay.sievers@vrfy.org, gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 7, 2010 at 12:07 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
>
> Just a quick note:
>
> On Sat, 06 Mar 2010 23:47:00 -0700 Grant Likely <grant.likely@secretlab.ca> wrote:
>>
>> diff --git a/drivers/macintosh/macio_asic.c b/drivers/macintosh/macio_asic.c
>> index 67fe13f..a5806ab 100644
>> --- a/drivers/macintosh/macio_asic.c
>> +++ b/drivers/macintosh/macio_asic.c
>> @@ -40,8 +40,7 @@ static struct macio_chip      *macio_on_hold;
>>  static int macio_bus_match(struct device *dev, struct device_driver *drv)
>>  {
>>       struct macio_dev * macio_dev = to_macio_device(dev);
>> -     struct macio_driver * macio_drv = to_macio_driver(drv);
>> -     const struct of_device_id * matches = macio_drv->match_table;
>> +     const struct of_device_id * matches = drv->match_table;
>                                                   ^^^^^^^^^^^
> of_match_table

Heh.  Oops.  I fixed that in my local directory when compile testing,
but neglected to refresh the patch.

Thanks,
g.
