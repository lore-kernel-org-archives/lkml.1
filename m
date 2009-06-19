Return-Path: <linux-kernel-owner+w=401wt.eu-S1753133AbZFSUUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbZFSUUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 16:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbZFSUUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 16:20:12 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:44473 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbZFSUUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 16:20:11 -0400
Message-ID: <4A3BF2FA.2010708@msgid.tls.msk.ru>
Date: Sat, 20 Jun 2009 00:20:10 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: ronis@ronispc.chem.mcgill.ca, linux-kernel@vger.kernel.org
Subject: Re: Panic booting 2.6.30
References: <1245439404.25076.7.camel@ronispc.chem.mcgill.ca>	 <4A3BE7EA.4050800@msgid.tls.msk.ru> <dd18b0c30906191255h7d0c6bcfx58f32d4b34e13c34@mail.gmail.com>
In-Reply-To: <dd18b0c30906191255h7d0c6bcfx58f32d4b34e13c34@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Mattock wrote:
> On Fri, Jun 19, 2009 at 12:32 PM, Michael Tokarev<mjt@tls.msk.ru> wrote:
>> David Ronis wrote:
>>> I've just upgraded an older machine (a P3 running slackware 11.0) from
>>> 2.6.26.5 to 2.6.30; the build was uneventful.  However, on reboot (using
>>> lilo) I get:
>>>
>>> VSF:  Cannot open root device "hda2" or unknown-block(0,0)
>>> Please append a correct root= boot option; here are the available
>>> partions:     <====== nothing shows here...
>>> Kernel-Panic - not syncing.
>>>
>>> I had rebooted with and without root=hda2.   The old kernel is still
>>> usable.
>>>
>>> Lilo.conf looks like:
>> Add large-memory option to lilo.conf
> 
> check  /dev/hda*  to see
> if it renamed itself to /dev/sda*

It cant "rename itself".

The difference between sd* and hd* is different driver for the
controller - either old good ide code (like piix) - that's hd*,
or libata-based code (ata_piix).  Which one is compiled into
your kernel or gets loaded by initrd is controlled by you, not
by kernel or drivers.

/mjt
