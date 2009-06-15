Return-Path: <linux-kernel-owner+w=401wt.eu-S1765769AbZFOUVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765769AbZFOUVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 16:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbZFOUVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 16:21:00 -0400
Received: from 195-23-16-24.net.novis.pt ([195.23.16.24]:52457 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbZFOUVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 16:21:00 -0400
Message-ID: <4A36A7ED.2050702@grupopie.com>
Date: Mon, 15 Jun 2009 20:58:37 +0100
From: Rui Santos <rsantos@grupopie.com>
Organization: GrupoPIE, Portugal SA
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: Stephen Clark <sclark46@earthlink.net>,
       Denys Fedoryschenko <denys@visp.net.lb>,
       Johannes Dewender <arch@jonnyjd.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Frans Pop <elendil@planet.nl>,
       Rutger Nijlunsing <bugzilla.kernel@tux.tmfweb.nl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andriy Gapon <avg@icyb.net.ua>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [WATCHDOG] iTCO_wdt.c - ICH9 reboot issue - testing wanted
References: <20090430094918.GC4141@infomag.iguana.be> <4A2967F6.2000303@grupopie.com> <20090610081845.GH16090@infomag.iguana.be>
In-Reply-To: <20090610081845.GH16090@infomag.iguana.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wim Van Sebroeck wrote:
> Hi Rui,
>   

Hi Wim,

>   
>> With your patch, the Intel DG35EC board will not allow my distribution
>> reboot or halt the machine. In order to circumvent that problem, I've
>> made a few addition to your previous patch witch allows the restore of
>> the changed Bit 0 to it's previous value if the module is unloaded.
>> My only doubt is if it should be done every time the gbl_smi_en is zero,
>> or in conjunction with nowayout when the value also equals zero. This
>> patch has what I described and a commented gbl_smi_en only.
>>     
>
> Forget the previous patch. I don't like having this hack in the main iTCO_wdt code.
> So I added it to the iTCO_vendor_support code with the necessary warnings.
> Can you test this (please note that the iTCO_vendor_support module needs to be
> loaded with the vendorsupport=911 module parameter).
>   

It's working like a charm. Also, the Bit 0 is changed to its original
value, so all reboots work.
I've tested on 2.6.30 and 2.6.27 ( with a few mods... ).

> Thanks in advance,
>   

Thank you,

> Wim.
>   

Rui

