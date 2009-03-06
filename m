Return-Path: <linux-kernel-owner+w=401wt.eu-S1757403AbZCFStz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbZCFStz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 13:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565AbZCFStn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 13:49:43 -0500
Received: from mx2.mail.ru ([94.100.176.16]:8132 "EHLO mx2.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462AbZCFStm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 13:49:42 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [PATCH] toshiba_acpi: Add full hotkey support
To: dsilvers@simtec.co.uk, mjg59@srcf.ucam.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Fri, 06 Mar 2009 21:49:36 +0300
References: <20090306003941.GA32403@srcf.ucam.org> <20090306005234.GA32539@srcf.ucam.org> <1236330536.12838.2.camel@hughsie-work.lan> <1236332843.19146.4.camel@petitemort> <20090306095623.GA6014@srcf.ucam.org> <1236333861.19146.9.camel@petitemort> <20090306100951.GA6268@srcf.ucam.org> <1236334376.19146.11.camel@petitemort> <20090306101533.GA6408@srcf.ucam.org> <1236334909.19146.16.camel@petitemort>
User-Agent: KNode/0.99.01
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Message-Id: <E1Lff74-000Hwq-00.arvidjaar-mail-ru@mx2.mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Silverstone wrote:

> On Fri, 2009-03-06 at 10:15 +0000, Matthew Garrett wrote:
>> > I see. One other thing occurred to me. Is there any way for Hal to know
>> > that the notify stuff is in place and thus doesn't need to
>> > poll /proc/acpi/toshiba/keys? Otherwise it's going to poll it anyway
>> > which fails to remove the periodic wakeups.
>> No. Distributions should build without --enable-toshiba if they ship a
>> kernel with this functionaliy.
> 
> This only makes sense if all the rest of /proc/acpi/toshiba/* is now
> implemented in proper modern kernel facilities.

I guess Matthew refers to HAL build switch. In which case only 
/proc/acpi/toshiba/keys is relevant, other files are not used by this HAL 
add-on.

In any case, as I mentioned, this file has to be removed if patch is 
implemented as it is effectively no-op then.

> I noticed rfkill
> switches (although I'll have to see if another is needed for the HSDPA
> modems in modern laptops) and a proper brightness control. I assume
> xrandr does what video did, which just leaves the fan control.
> 

There are two ways to control fan here - standard ACPI and HCI. ACPI does 
not work. Is there any standard framework for fan control (a la 
power_supply) where HCI version could be plugged in?
