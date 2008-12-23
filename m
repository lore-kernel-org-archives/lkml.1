Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678AbYLWHE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbYLWHE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 02:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbYLWHEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 02:04:48 -0500
Received: from wp093.webpack.hosteurope.de ([80.237.132.100]:60288 "EHLO
	wp093.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751203AbYLWHEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 02:04:48 -0500
Message-ID: <49508D8B.20801@romal.de>
Date: Tue, 23 Dec 2008 08:04:43 +0100
From: "Robert M. Albrecht" <linux@romal.de>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; de; rv:1.9.1b3pre) Gecko/20081201 Thunderbird/3.0b1
MIME-Version: 1.0
To: Philip Langdale <philipl@overt.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Bug 10173 / Bluetooth on Toshiba & Compal laptops
References: <4946BE11.5080501@romal.de> <bbd413efc08484efe55c558e9a0980fb@localhost> <4946DB8C.5000308@romal.de> <5a670e0fe13a5f433ef207efefd71ca2@localhost>
In-Reply-To: <5a670e0fe13a5f433ef207efefd71ca2@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;linux@romal.de;1230015887;49b767e4;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the module is loaded:

[root@tycho ~]# lsmod | grep kill
rfkill                 11288  2 toshiba_acpi
[root@tycho ~]#

The wlan-devices works ok, it get's disabled and enabled via rfkill. But 
the bluetooth-device does not get reeanbled after switching it off.

cu romal




Am 15.12.2008 23:47 Uhr, schrieb Philip Langdale:
> On Mon, 15 Dec 2008 23:34:52 +0100, "Robert M. Albrecht"<mail@romal.de>
> wrote:
>> Hi Phil,
>>
>> anything I can do ? Providing some logs or granting ssh access to the
>> machine to have a look ?
>
> If necessary, that would be useful. However, the first question to ask is
> actually
> related to my possibility C) - which I'm now re-evaluating as much more
> likely.
>
> If you don't load the 'rfkill-input' module, then there is no policy
> applied to
> killswitch handling. The core driver puts the device in the SOFT_BLOCKED
> state
> when the de-assert the hardware switch. rfkill-input contains the policy
> that
> decides to go one step further and re-enable the device. This module has no
> hardware dependencies so it is not automatically loaded - you must do it
> explicitly yourself.
>
> If that's not your problem, then we'll have to dig deeper.
>
> --phil
>
>
