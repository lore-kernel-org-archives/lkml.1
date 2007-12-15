Return-Path: <linux-kernel-owner+w=401wt.eu-S1764268AbXLOHYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764268AbXLOHYA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 02:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbXLOHXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 02:23:53 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:46079 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbXLOHXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 02:23:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=l2s11VMr/sVeroc3+33fmZUtJsBdaRNlD2V250rvo491NX/KMaLkoewdcMtXmrFReaFzFweJ7aU20YbmEHgTDbs9VLfbxWCMMHFN6BMms9BkCriPszKf6k+hG+tUqzk4MbOhzy7yAP0bDZYp/8hehJ/Re4iGGmDwvR3fykG0Mak=
Message-ID: <476380A8.1010006@gmail.com>
Date: Sat, 15 Dec 2007 08:22:16 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Chuck Ebbert <cebbert@redhat.com>, Rene Herman <rene.herman@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       Pavel Machek <pavel@ucw.cz>, Andi Kleen <andi@firstfloor.org>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       David Newall <david@davidnewall.com>, Paul Rolland <rol@as2917.net>,
       Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: More info on port 80 symptoms on MCP51 machine.
References: <475DE6F4.80702@zytor.com> <475DEB23.1000304@davidnewall.com> <20071211084059.3d03e11d@tux.DEF.witbe.net> <475E5D4B.8020101@keyaccess.nl> <475E7DC2.4060509@davidnewall.com> <475E8D91.20201@keyaccess.nl> <475E95A3.3070801@davidnewall.com> <Pine.LNX.4.61.0712111024060.22976@chaos.analogic.com> <20071211163017.GD16750@one.firstfloor.org> <475EBFBA.6090301@keyaccess.nl> <20071211191649.GB3437@elf.ucw.cz> <475EEC75.80609@keyaccess.nl> <47603F66.3070108@reed.com> <476043DA.5000602@keyaccess.nl> <47604B71.7090902@keyaccess.nl> <47604D1D.8000003@zytor.com> <4762FE3E.5020402@redhat.com>
In-Reply-To: <4762FE3E.5020402@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-12-07 23:05, Chuck Ebbert wrote:

> On 12/12/2007 04:05 PM, H. Peter Anvin wrote:

>> Rene Herman wrote:

>>> By the way, _does_ anyone have a contact at nVidia who could clarify?
>>> Alan maybe? I'm quite curious what they did...
>>>
>>> Summary:
>>>
>>> Unless after booting with "acpi=off", outputs to port 0x80 (the legacy
>>> way to delay I/O) reliably, but not immediately, hang MCP51 machines.
>>> Outputs to port 0xed do not indicating it's a not a generic bus abort
>>> problem.
>>>
>> Sorry, the first sentence didn't parse unambiguously for me.  Do you
>> mean "acpi=off" works, or that "acpi=off" allows *subsequent* boots to
>> work?
>>
>> I have some people at nVidia I can probably ping.

Sorry, didn't see this again due to aforementioned horseshit ISP. "acpi=off" 
works it seems. Report from David Reed here:

http://lkml.org/lkml/2007/12/12/291

> Have them search on Google for:
> 
>   hp tx1000 noapic
> 
> :)

Rene.


