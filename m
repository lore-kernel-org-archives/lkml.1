Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbYKCIfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbYKCIfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 03:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbYKCIff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 03:35:35 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:41615 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbYKCIff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 03:35:35 -0500
Message-ID: <ac3eb2510811030035y3e72bc9dt732c4a3688bae3ec@mail.gmail.com>
Date: Mon, 3 Nov 2008 09:35:32 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: sound: struct device - replace bus_id with dev_name(), dev_set_name()
Cc: linux-kernel <linux-kernel@vger.kernel.org>, "Greg KH" <greg@kroah.com>
In-Reply-To: <s5h3ai9w7wr.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225594235.2142.14.camel@nga.site> <s5hy702ide3.wl%tiwai@suse.de>
	 <s5h3ai9w7wr.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2008 at 09:06, Takashi Iwai <tiwai@suse.de> wrote:
> At Sun, 02 Nov 2008 12:19:16 +0100,
> I wrote:
>>
>> At Sun, 02 Nov 2008 03:50:35 +0100,
>> Kay Sievers wrote:
>> >
>> > --- a/sound/isa/ad1848/ad1848.c
>> > +++ b/sound/isa/ad1848/ad1848.c
>> > @@ -70,15 +70,15 @@ static int __devinit snd_ad1848_match(st
>> >             return 0;
>> >
>> >     if (port[n] == SNDRV_AUTO_PORT) {
>> > -           snd_printk(KERN_ERR "%s: please specify port\n", dev->bus_id);
>> > +           snd_printk(KERN_ERR "%s: please specify port\n", dev_name(dev));
>>
>> All the changes in sound/isa/* seem to be better fixed by replacement
>> with dev_err().
>>
>> Other changes look good to me.
>
> I dropped sound/isa/* changes from your patch and applied to sound git
> tree now.
>
> The sound/isa* parts are replacement with dev_err() and co as well, so
> there is no longer dev->bus_id in sound directory.

Very nice. Thanks for your prompt reply, it helps a lot,
Kay
