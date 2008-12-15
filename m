Return-Path: <linux-kernel-owner+w=401wt.eu-S1755137AbYLOWcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbYLOWcQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 17:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbYLOWcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 17:32:01 -0500
Received: from usul.saidi.cx ([204.11.33.34]:60055 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751625AbYLOWcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 17:32:00 -0500
To: "Robert M. Albrecht" <mail@romal.de>
Subject: Re: Bug 10173 / Bluetooth on Toshiba & Compal laptops
MIME-Version: 1.0
Date: Mon, 15 Dec 2008 17:35:30 -0500
From: Philip Langdale <philipl@overt.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4946BE11.5080501@romal.de>
References: <4946BE11.5080501@romal.de>
Message-ID: <bbd413efc08484efe55c558e9a0980fb@localhost>
User-Agent: RoundCube Webmail/0.2-beta
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 15 Dec 2008 21:29:05 +0100, "Robert M. Albrecht" <mail@romal.de>
wrote:
> Hi,
> 
> anyone working on toshiba_acpi or omnibook module ?
> 
> toshiba_acpi:
> 
>
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next-2.6.git;a=commit;h=c41a40c58b623f97dd2e23aa3baab2cedb47d99f
> 
> The rfkill-switch does not work. The device is disabled when switched of,

> but it gets not reenabled. But the bluetooth dongle is enabled after
> booting.
> 
> AFAIK this only works for Toshiba manufactured devices (toshiba_acpi),
not 
> for Compal manufactured.

The officially stated maintainer for toshiba_acpi seems to be out of
contact,
but I'm responsible for the rfkill patch. I can only say that the patch is
designed
to re-enable bluetooth when the hardware kill switch is de-asserted and
that I tested
this to work before the change was merged. If it doesn't work now, it's
either:

a) a regression introduced by one of the fixes for laptops with no
bluetooth device. I
   consider this unlikely.

b) different behaviour in your model of toshiba vs. mine

c) a difference in how you've got the kill switch configured in sysfs. Not
sure if that's
   even possible.

As you might conclude, I suspect B.

--phil
