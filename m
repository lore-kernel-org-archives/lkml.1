Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbYLOWfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbYLOWfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 17:35:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbYLOWez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 17:34:55 -0500
Received: from wp093.webpack.hosteurope.de ([80.237.132.100]:46730 "EHLO
	wp093.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751443AbYLOWey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 17:34:54 -0500
Message-ID: <4946DB8C.5000308@romal.de>
Date: Mon, 15 Dec 2008 23:34:52 +0100
From: "Robert M. Albrecht" <mail@romal.de>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; de; rv:1.9.1b3pre) Gecko/20081201 Thunderbird/3.0b1
MIME-Version: 1.0
To: Philip Langdale <philipl@overt.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Bug 10173 / Bluetooth on Toshiba & Compal laptops
References: <4946BE11.5080501@romal.de> <bbd413efc08484efe55c558e9a0980fb@localhost>
In-Reply-To: <bbd413efc08484efe55c558e9a0980fb@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;mail@romal.de;1229380494;9c7275e5;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Phil,

anything I can do ? Providing some logs or granting ssh access to the 
machine to have a look ?

cu romal

www.romal.de
blog.romal.de


Am 15.12.2008 23:35 Uhr, schrieb Philip Langdale:
> On Mon, 15 Dec 2008 21:29:05 +0100, "Robert M. Albrecht"<mail@romal.de>
> wrote:
>> Hi,
>>
>> anyone working on toshiba_acpi or omnibook module ?
>>
>> toshiba_acpi:
>>
>>
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next-2.6.git;a=commit;h=c41a40c58b623f97dd2e23aa3baab2cedb47d99f
>> The rfkill-switch does not work. The device is disabled when switched of,
>
>> but it gets not reenabled. But the bluetooth dongle is enabled after
>> booting.
>>
>> AFAIK this only works for Toshiba manufactured devices (toshiba_acpi),
> not
>> for Compal manufactured.
>
> The officially stated maintainer for toshiba_acpi seems to be out of
> contact,
> but I'm responsible for the rfkill patch. I can only say that the patch is
> designed
> to re-enable bluetooth when the hardware kill switch is de-asserted and
> that I tested
> this to work before the change was merged. If it doesn't work now, it's
> either:
>
> a) a regression introduced by one of the fixes for laptops with no
> bluetooth device. I
>     consider this unlikely.
>
> b) different behaviour in your model of toshiba vs. mine
>
> c) a difference in how you've got the kill switch configured in sysfs. Not
> sure if that's
>     even possible.
>
> As you might conclude, I suspect B.
>
> --phil
>
