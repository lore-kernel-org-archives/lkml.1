Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbYKDAvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbYKDAvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 19:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbYKDAvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 19:51:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43766 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbYKDAvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 19:51:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Nico -telmich- Schottelius" <nico-linux-next@schottelius.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: 2.6.28-rc3(-next20081103) suspend issues on Lenovo X200
Date: Tue, 4 Nov 2008 01:55:59 +0100
User-Agent: KMail/1.9.9
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20081103153945.GA20618@denkbrett.schottelius.org>
In-Reply-To: <20081103153945.GA20618@denkbrett.schottelius.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811040155.59933.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 3 of November 2008, Nico -telmich- Schottelius wrote:
> Updating my last post, system now runs with
> the new Debian xserver-xorg-intel package:
> 
> 2.6.28-rc3 and 2.6.28-rc3-next-20081103: acpi_sleep=s3_bios
>    - suspend on console works
>    - wakeup on console works
>    - xorg (intel 2.3.2-2+lenny5) works
>    - suspend on xorg works
>    - wakeup on xorg is BROKEN:
>       - console (kernel messages) is seen for a few seconds
>       - kernel switches back to X
>       - screen is partly drawn: X cursor is shown, background, no windows
>       - system hard reboots after about 20 seconds (watchdog?)
> 
> The Debian packages includes the lates G45 bugfix:
> 
> http://packages.debian.org/changelogs/pool/main/x/xserver-xorg-video-intel/xserver-xorg-video-intel_2.3.2-2+lenny5/changelog
> 
> So I'm waiting for your input on where to update what next ;-)

Jesse, any ideas?  Can that be related to the DRM problem with radeon?

Thanks,
Rafael
