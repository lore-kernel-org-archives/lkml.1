Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbZIUPHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbZIUPHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 11:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756310AbZIUPHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 11:07:22 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:48625 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756265AbZIUPHV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 11:07:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vfbKXqSELvROpRft9w+BhuBNm4HJ7QCR3KQoL0kWKLEbLrBqvO7P+sf25iWa0ZE3FP
         ZwqBjgTQ/D/Xz1JatD0fYGRBx3zRZQ8gVUfqXqA3LzMlqC+OoBYw7l5TE1SqIYzbuXUv
         dMVU54Pm93skdnZjUTPP6vD9ZVSSSv4V77WiQ=
MIME-Version: 1.0
In-Reply-To: <200909211102.25354.gene.heskett@verizon.net>
References: <c43b2e150909200120kf87cdc2oabafea8abbf01227@mail.gmail.com>
	 <200909202035.54220.gene.heskett@verizon.net>
	 <68676e00909210243h7aab926cr225779826743ed33@mail.gmail.com>
	 <200909211102.25354.gene.heskett@verizon.net>
Date: Mon, 21 Sep 2009 17:07:23 +0200
Message-ID: <68676e00909210807h71171ae6l59eb4e8eb972c161@mail.gmail.com>
Subject: Re: [lm-sensors] it87 sensors need an ACPI driver (2.6.31)
From: Luca Tettamanti <kronos.it@gmail.com>
To: Gene Heskett <gene.heskett@verizon.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 5:02 PM, Gene Heskett <gene.heskett@verizon.net> wrote:
> On Monday 21 September 2009, Luca Tettamanti wrote:
>>On Mon, Sep 21, 2009 at 2:35 AM, Gene Heskett <gene.heskett@verizon.net>
> wrote:
>>> On Sunday 20 September 2009, Luca Tettamanti wrote:
>>>>On Sun, Sep 20, 2009 at 10:37 PM, Gene Heskett <gene.heskett@verizon.net>
>>>
>>> wrote:
>>>>> Jumping in the middle of this, I am another that it87 doesn't work very
>>>>> well for,  ASUS M2N SLI Deluxe board.
>>>>
>>>>Please define "doesn't work well". asus_atk0110 should handle that
>>>>board. In case of troubles enable CONFIG_HWMON_DEBUG_CHIP, load
>>>>asus_atk0110 and post the content of the kernel log.
>>>
>>> With that CONFIG_HWMON_DEBUG_CHIP enabled, dmesg (attached) looks semi-
>>> kosher, but neither gkrellm nor sensors can show me data until it87 is
>>> loaded.  I unloaded it87 and reloaded it several times just now.
>>>  Something funkity someplace...  Is there a new application I need to dl
>>> and install?
>>
>>You probably need to upgrade the lm-sensors package. Version 3.1.1 has
>>support for ACPI devices.
>>
> Its the latest in the F10 repos, Luca.  I have these:
>
> lm_sensors-3.0.2-1.fc10.i386
> lm_sensors-sensord-3.0.2-1.fc10.i386

Too old.

>  I also note that while asus_atk0110 is loaded, it has no link count in an
> lsmod output.  This has little or nothing to do with the lm_sensors version,
> when the kernel itself (2.6.31 final) doesn't get any real data.  Or can it?

Usage count is zero because nothing is using the driver ;-) As the
dmesg shows the driver is loaded and has correctly identified the
sensors.


> I've stumbled around is the /sys/fs tree looking for data, but wasn't able to
> do anything but get stuck in a re-entrant loop, that is a bowl of spaghetti,
> well stirred.

You'll find the relevant sysfs entries under /sys/class/hwmon/

Luca
