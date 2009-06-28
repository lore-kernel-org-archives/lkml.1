Return-Path: <linux-kernel-owner+w=401wt.eu-S1752992AbZF1LsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbZF1LsU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 07:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbZF1LsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 07:48:13 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:46172 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbZF1LsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 07:48:12 -0400
MIME-Version: 1.0
In-Reply-To: <1245842095.25547.5380.camel@macbook.infradead.org>
References: <1245527124.30962.14.camel@yio.site> <1245675383.25547.50.camel@macbook.infradead.org> 
	<1245832038.2483.3.camel@yio.site> <1245842095.25547.5380.camel@macbook.infradead.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sun, 28 Jun 2009 13:47:57 +0200
Message-ID: <ac3eb2510906280447kdd5aa98o2baa239521752066@mail.gmail.com>
Subject: Re: BUS_ID_SIZE is going away
To: David Woodhouse <dwmw2@infradead.org>
Cc: catalin.marinas@arm.com, Greg KH <greg@kroah.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Takashi Iwai <tiwai@suse.de>, "David S. Miller" <davem@davemloft.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 13:14, David Woodhouse<dwmw2@infradead.org> wrote:
> On Wed, 2009-06-24 at 10:27 +0200, Kay Sievers wrote:
>> On Mon, 2009-06-22 at 13:56 +0100, David Woodhouse wrote:
>> > I have this queued for 2.6.31 but have been on jury duty for the last 2
>> > weeks so I'm hoping to get the pull request to Linus today now that I'm
>> > free.
>>
>> The old one is gone, but seems you merged a new one with BUS_ID_SIZE :)
>>
>>   ./drivers/mtd/maps/integrator-flash.c:#define SUBDEV_NAME_SIZE      (BUS_ID_SIZE + 2)
>
> Hm, true :)

Seems, it's the last one left. In case the "real" fix you are working
on is not ready to apply, care to push out a change, so we can finally
get rid of itl? Or let me know, and we can replace it with "20" along
with the removal from the driver core.

Thanks,
Kay
