Return-Path: <linux-kernel-owner+w=401wt.eu-S1753022AbXCUWvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbXCUWvH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbXCUWvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:51:07 -0400
Received: from smtp.ono.com ([62.42.230.12]:11817 "EHLO resmaa01.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753022AbXCUWvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:51:06 -0400
Date: Wed, 21 Mar 2007 23:50:52 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc4: extremely high power consumption
Message-ID: <20070321235052.6b00cfac@werewolf-wl>
In-Reply-To: <20070321222938.GB6060@elf.ucw.cz>
References: <20070321222938.GB6060@elf.ucw.cz>
X-Mailer: Claws Mail 2.8.1cvs32 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 23:29:38 +0100, Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> Today I heard fans running a bit too much. I checked with top, and got
> no obvious power hog. And now acpi battery says:
> 
> root@amd:/data/l/zaurus/oz.spitz.3541# cat
> /proc/acpi/battery/BAT0/state
> present:                 yes
> capacity state:          ok
> charging state:          discharging
> present rate:            35248 mW
> remaining capacity:      1850 mWh
> present voltage:         14259 mV
> 
> ...35W! This machine normally eats 14W.
> 
> Now it got better, I still see nothing at top... 22W. That's still 8W
> more than it should be. What is going on?
> 								Pavel

Periodical disk writes that eat your battery ?
No display dimming ?
No cpu speed reduction ?

Just ideas...

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.20-jam05 (gcc 4.1.2 20070302 (prerelease) (4.1.2-1mdv2007.1)) #2 SMP PREEMPT
