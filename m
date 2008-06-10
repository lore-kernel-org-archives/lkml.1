Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbYFJSGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbYFJSGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 14:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbYFJSGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 14:06:30 -0400
Received: from outbound-mail-114.bluehost.com ([69.89.24.4]:34662 "HELO
	outbound-mail-114.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752218AbYFJSG3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 14:06:29 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Romano Giannetti <romanol@upcomillas.es>
Subject: Re: [regression?] Sometime (often) X come out blank (black screen) on cold boot - Intel chipset
Date: Tue, 10 Jun 2008 11:06:23 -0700
User-Agent: KMail/1.9.9
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Justin Madru <jdm64@gawab.com>
References: <1213101501.21041.9.camel@pern>
In-Reply-To: <1213101501.21041.9.camel@pern>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806101106.23899.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 10, 2008 5:38 am Romano Giannetti wrote:
> I just opened this: http://bugzilla.kernel.org/show_bug.cgi?id=10892 . I
> think itś a regression, but (read the description) I am not so sure, so
> I checked regression but I have not blocked Rafael's metabug.
>
> Latest working kernel version: 2.6.25
> Earliest failing kernel version: After 2.6.25, exatcly don't know, probably
> 2.6.26-rc3
> Distribution:Ubuntu 8.04 Hardy
> Hardware Environment: toshiba U305 intel-based laptop, see
> http://bugzilla.kernel.org/attachment.cgi?id=16067&action=view
> Software Environment:xserver-xorg-video-intel  2:2.2.1-1ubuntu12, see also
> http://bugzilla.kernel.org/attachment.cgi?id=16066&action=view
> Problem Description:
>
> Sometime, on cold boot (after the laptop has been shut off), when the
> screen switch from the Ubuntu startup to gdm, the screen goes blank.
> Forever. Rebooting (warm) with the same kernel cures it, sometime. If I
> reboot 2.6.25 it cures it everytime.
>
> Otherwise, the system seems to be working.
>
> It was difficult to see because I almost never do a cold boot, the laptop
> is either sleeping (s2ram) or on, or (warm) rebooted when I test a new
> kernel.
>
> Helps / tricks to gather more data when it happens are welcome.

This sounds like a DUP; I remember Justin Madru had a similar issue (with 
Ubuntu & gdm even iirc).

Is there any way you could run the latest git bits of the Intel X driver?  
I've added some debugging that could catch at least one of the common reasons 
why the display would blank like that...

Thanks,
Jesse
