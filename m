Return-Path: <linux-kernel-owner+w=401wt.eu-S1753695AbYAHRZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbYAHRZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 12:25:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbYAHRYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 12:24:54 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:62408 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbYAHRYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 12:24:53 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 18.85.9.106
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+pQ/3HcGsH4SpdqwiP85vi
Message-ID: <4783B1B2.6070005@reed.com>
Date: Tue, 08 Jan 2008 12:24:02 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071115 Fedora/2.0.0.9-1.fc8 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Rene Herman <rene.herman@keyaccess.nl>,
       Bodo Eggert <7eggert@gmx.de>, Christer Weinigel <christer@weinigel.se>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
References: <9BdU5-1YW-9@gated-at.bofh.it> <4782C017.3000208@zytor.com> <4782D407.7010301@reed.com> <200801081810.58904.linux@rainbow-software.org>
In-Reply-To: <200801081810.58904.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Windows these days does delays with timing loops or the scheduler.  It 
doesn't use a "port".  Also, Windows XP only supports machines that tend 
not to have timing problems that use delays.  Instead, if a device takes 
a while to respond, it has a "busy bit" in some port or memory slot that 
can be tested.

Almost all of the issues in Linux where _p operations are used are (or 
should be) historical - IMO.

Ondrej Zary wrote:
> On Tuesday 08 January 2008 02:38:15 David P. Reed wrote:
>   
>> H. Peter Anvin wrote:
>>     
>>> And shoot the designer of this particular microcontroller firmware.
>>>       
>> Well, some days I want to shoot the "designer" of the entire Wintel
>> architecture...  it's not exactly "designed" by anybody of course, and
>> today it's created largely by a collection of Taiwanese and Chinese ODM
>> firms, coupled with Microsoft WinHEC and Intel folks.  At least they
>> follow the rules and their ACPI and BIOS code say that they are using
>> port 80 very clearly if you use PnP and ACPI properly.  And in the old
>> days, you were "supposed" to use the system BIOS to talk to things like
>> the PIT that had timing issues, not write your own code.
>>     
>
> Does anyone know what port does Windows use? I'm pretty sure that it isn't 80h 
> as I run Windows 98 often with port 80h debug card inserted. The last POST 
> code set by BIOS usually remains on the display and only changes when BIOS 
> does something like suspend/resume. IIRC, there was a program that was able 
> to display temperature from onboard sensors on the port 80h display that's 
> integrated on some mainboards.
>
>   
