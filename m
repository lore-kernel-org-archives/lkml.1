Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbYABNNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbYABNNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 08:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754404AbYABNNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 08:13:07 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:60209 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbYABNNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 08:13:06 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/sQtvruEXACg5dWUqTc5wp
Message-ID: <477B8D75.3010808@reed.com>
Date: Wed, 02 Jan 2008 08:11:17 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071115 Fedora/2.0.0.9-1.fc8 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@gmail.com>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
References: <47667366.7010405@gmail.com> <4766AE88.4080904@zytor.com> <4766D175.7040807@reed.com> <20071217212509.5edaa372@the-village.bc.nu> <477A634C.8040000@reed.com> <20080101161557.3ce2d5f8@the-village.bc.nu> <20080101164338.GA901@elte.hu> <20080101173212.1bba4939@the-village.bc.nu> <20080101184524.GA6655@elte.hu> <20080101210734.03414931@the-village.bc.nu> <20080102100436.GB4389@elte.hu>
In-Reply-To: <20080102100436.GB4389@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI - another quirky Quanta motherboard from HP, with DMI readings 
reported to me.

-------- Original Message --------
Date: 	Wed, 2 Jan 2008 16:23:27 +1030
From: 	Joel Stanley <joel.stanley@adelaide.edu.au>
To: 	David P. Reed <dpreed@reed.com>
Subject: 	Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)



On Dec 30, 2007 1:13 AM, David P. Reed <dpreed@reed.com> wrote:
> I have also attached a c program that only touches port 80.  Compile it
> for 32-bit mode (see comment), run it as root, and after two or three
> runs, it will hang a system that has the port 80 bug.

Using port80.c, I could hard lock a HP Pavilion tx1000 laptop on the
first go. This was with ubuntu hardy's stock kernel (a 2.6.24-rc)

> dmidecode -s baseboard-manufacturer
> dmidecode -s baseboard-product-name

Quanta
30BF

Tonight, I will try compiling a kernel with these values added to your patch.

Some history, feel free to ignore if it's not relevant: ubuntu
feisty's 2.6.22 based kernel worked fine, irc. We were having issues
with sound, so tried fedora8's .23 based kernel, but this would
sporadically hard lock. Ubuntu hardy's 2.6.24 appeared fine, for the 2
hours or so I used it last night, until using the port80.c program,
obviously.

Cheers,

Joel


