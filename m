Return-Path: <linux-kernel-owner+w=401wt.eu-S1760628AbZJNWDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628AbZJNWDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 18:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbZJNWDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 18:03:36 -0400
Received: from lucidpixels.com ([75.144.35.66]:47832 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748AbZJNWDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 18:03:35 -0400
Date: Wed, 14 Oct 2009 18:02:59 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: bruce.w.allan@intel.com
Subject: Intel DP55KG BIOS Bug (reboot hangs, is Intel aware of the
 problem?)
Message-ID: <alpine.DEB.2.00.0910141756440.2653@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have tried the following kernel parameters with '*' and reboot=b,
reboot=h and reboot=s.

-----------------------------------------------------------------------

Rebooting

    reboot=b[ios] | t[riple] | k[bd] | a[cpi] | e[fi] [, [w]arm | [c]old]
*   bios    Use the CPU reboot vector for warm reset
    warm   Don't set the cold reboot flag
    cold   Set the cold reboot flag
    triple Force a triple fault (init)
*   kbd    Use the keyboard controller. cold reset (default)
    acpi   Use the ACPI RESET_REG in the FADT. If ACPI is not configured or the
           ACPI reset does not work, the reboot path attempts the reset using
           the keyboard controller.
*   efi    Use efi reset_system runtime service. If EFI is not configured or the
           EFI reset does not work, the reboot path attempts the reset using
           the keyboard controller.

    Using warm reset will be much faster especially on big memory
    systems because the BIOS will not go through the memory check.
    Disadvantage is that not all hardware will be completely reinitialized
    on reboot so there may be boot problems on some systems.

*   reboot=force

None of which work.

-----------------------------------------------------------------------

It appears earlier Intel boards also suffered the same problem:

Subject: Re: Machine restart doesn't work - Intel 965G, 2.6.19-rc2
http://lkml.indiana.edu/hypermail/linux/kernel/0610.2/2215.html

Are those at Intel aware of this problem?

I have tried many different options/settings, nothing seems to work.

All workaround are unsuccessful.

It appears the dmidecode is requested for these sorts of problems, that is 
available here:
http://home.comcast.net/~jpiszcz/20091014/dmidecode.txt

Are there any other workarounds until Intel comes out with a patch/new 
BIOS?  Aside from shutting the system off and using wake on lan?

Justin.

