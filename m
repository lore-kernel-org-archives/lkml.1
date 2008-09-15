Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbYIOPCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbYIOPCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 11:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbYIOPBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 11:01:52 -0400
Received: from ptb-relay02.plus.net ([212.159.14.146]:59556 "EHLO
	ptb-relay02.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbYIOPBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 11:01:51 -0400
Message-ID: <48CE78F0.9050805@yahoo.com>
Date: Mon, 15 Sep 2008 16:02:08 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
Newsgroups: fa.linux.kernel
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>,
       acpi4asus-user@lists.sourceforge.net
Subject: Re: Turning off camera also kills card reader on EeePC 900
References: <fa.AGK4P0BJyB1JXP0f1hBx9GtBh+c@ifi.uio.no> <fa.ifmgGzvpZjuOrzmMPG9PMGHUVn4@ifi.uio.no> <fa.jeJ+IlDCDZAKTug+iVXTMjdMIyk@ifi.uio.no>
In-Reply-To: <fa.jeJ+IlDCDZAKTug+iVXTMjdMIyk@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: bac6dce1c1f020e022b593e8c4b3aeff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alan Jenkins wrote:
> Ok.  So the platform driver settings do match those in the BIOS.  My
> guess would be the platform driver is fine and the BIOS screws up.

I was afraid you were going to say that.

> The "HC died" message is interesting.  Sounds like the controller for
> these two USB devices stops working.  Maybe try unloading and reloading
> the ehci module?  I don't think I can help any more though.

I compiled the kernel without module support so unless there's some 
sysfs trick that can be done...

> - Are any BIOS upgrades available?  None of them mention this problem,
> but the descriptions often miss out details. [1][2]

For some reason I thought I had once seen an 804 BIOS but I only see 802 
on the EeePC 900 page (link below) and the even older 704 BIOS on 
ftp://ftp.asus.com/pub/ASUS/EeePC/EeePC900/ .

> - It might be necessary to compare with the pre-installed OS
>  - Is the pre-installed kernel any better (files might be under
> /proc/acpi/asus instead)?  I guess you might not have the time or
> resources to test that though.

The Xandros 2.6.21.4-eeepc install has the following files in 
/proc/acpi/asus/
brn camera cardr cpufv disp hdps init type wlan

I have no idea what cpufv, disp, hdps, init or type are. Doing echo 1 > 
camera && echo 0 > camera under this setup does NOT disappear the SD 
card. Additionally brn seems to really represent the current LCD 
brightness (whereas it does not on a stock kernel and seems to always be 
set to -19) and the hotkeys (e.g. for brightness) seem to respond far 
more quickly than the stock kernel too.

>  - The source code is... a 2Gb+ rar file someone would have to download
> and pick apart.

2.6Gbytes of multipart RAR. Joy.

 > [1] Asus downloads <http://eeepc.asus.com/global/download.htm>

This link seems to be for the 701 only.

Does anyone know if the archives on
http://support.asus.com/download/download_item_4.aspx?product=20&model=Eee%20PC%20900/Linux&SLanguage=en-us&os=5 
(release dates appear to be 5th September 2008) are actually any different?

(A brief aside. If you are a company doing seeking to do a source 
release of a Linux distribution, it might be a good idea to go for 
typical Unix formats. It is easier for folks if you package things as 
tar.bz2 or tar.gz files or even .zip rather than going for .rar . 
Additionally it is helpful if you split the just the kernel into an 
archive of its own).

--
Sitsofe
