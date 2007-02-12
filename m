Return-Path: <linux-kernel-owner+w=401wt.eu-S964885AbXBLL2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964885AbXBLL2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 06:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964868AbXBLL2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 06:28:05 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:55490 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964874AbXBLL1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 06:27:41 -0500
Message-ID: <45D04F30.2090600@gmail.com>
Date: Mon, 12 Feb 2007 12:27:44 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: albcamus <albcamus@gmail.com>
Cc: Reg Clemens <reg@dwf.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Why can't I build a running Kernel?
References: <200702081817.l18IHlbE027996@deneb.dwf.com>	 <45CB79CF.9010702@gmail.com> <df9815e70702120036k3e2a2a50re0dc2605c31766f3@mail.gmail.com>
In-Reply-To: <df9815e70702120036k3e2a2a50re0dc2605c31766f3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

albcamus napsal(a):
> 2007/2/9, Jiri Slaby <jirislaby@gmail.com>:
>> Reg Clemens napsal(a):
>> > Why can't I build a running Kernel?
>> > I have in the past, but since some time in the 2.6.19 series,
>> > I have got the following series of errors.
>> > Same thing now with 2.6.20.
>> >
>> > I build with:
>> >
>> >     make xconfig
>> >
>> > changing only the Processor type to Pentium4,
>> > then I
>> >
>> >     make bzImage
>> >     make modules
>> >     make modules_install
>> >     make install
>> >
>> > Fine everything builds, no errors.
>> > I then try booting, and I get 4 or 5 lines and then
>> >
>> >     Unable to access resume device (/dev/sda5)
>> >     mount: could not find filesystem '/dev/root'
>> >     < 4 more lines with setuproot and switchroot >
>> >
>> > and then
>> >
>> >     Kernel panic - not syncing: Attempting to kill init!
>> >
>> > Sigh.
>> > What has changed, what do I need to do to get this thing to boot?
>>
> I have the same problem with 2.6.19 and later. The previous kernel with
> same .config works, but it's not true for 2.6.19 and 2.6.30.
> 
> 
> 
> 
>> Re-enable sata/scsi/usb/whatever is your root behind stuff back again? 
>> What
>> does
>> your .config look like?
>>
>> regards,
> 
> I selected everything about ATA to <*> or <M>, and made initrd for the
> newly-built kernel, still unable to boot.
> 
> The .config was attached, I have kdb-4.4 patched.

Config seems to be fine. Please post
lspci -vvvxx

and lines from your boot loader.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
