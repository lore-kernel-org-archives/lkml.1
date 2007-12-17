Return-Path: <linux-kernel-owner+w=401wt.eu-S1765122AbXLQVw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765122AbXLQVw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:52:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763363AbXLQVwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:52:36 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:23002 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761569AbXLQVwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:52:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=iG2qWsmeBlSnBNxUgFI/RpmU44KsQIQm2iAYyS/g2IbPraiNWtLby9zymobBELOIVTm6fpRFbF4YnL6bcZ1R3i0mcHcV2wawym2jeU8VRsp2oxL96W0E/fam7KfZ6DFsvuU05Ab51mphbRHYMUxIkFnLVTckdY7Ho9TlAaEgMmY=
Message-ID: <4766EF28.5070807@keyaccess.nl>
Date: Mon, 17 Dec 2007 22:50:32 +0100
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Rene Herman <rene.herman@gmail.com>, Ingo Molnar <mingo@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       "David P. Reed" <dpreed@reed.com>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <476462BE.3030701@gmail.com>	<4764687D.6080609@zytor.com>	<476524DB.7020806@gmail.com>	<20071216152250.GA21245@elte.hu>	<4765D43E.1010800@gmail.com>	<20071217105744.GA14315@elte.hu>	<4766684D.40202@gmail.com>	<20071217130933.GB27992@elte.hu>	<47667812.8050708@gmail.com>	<47667A85.3080100@reed.com>	<20071217143900.GA16604@elte.hu> <20071217161243.05c32df4@the-village.bc.nu> <4766E086.9090500@gmail.com> <4766E2B5.8080001@zytor.com> <4766EB45.6010402@keyaccess.nl> <4766ECE2.1060604@zytor.com>
In-Reply-To: <4766ECE2.1060604@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
From: Rene Herman <rene.herman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17-12-07 22:40, H. Peter Anvin wrote:

> Rene Herman wrote:
>>
>> Well, yes, I guess that does make sense. It's back again. Named the 
>> choices "standard" and "alternate" again as I feel "0x80" and "0xed" 
>> suggest they're free values a bit too much but if anyone feels 
>> strongly about it, so be it.
>>
> 
> They ARE -- or really, should be, free values (0xeb and 0xf0 are other 
> reasonable values, for example.)

I was afraid someone would say that. Making a random port available is fine 
for testing purposes but a failry dangerous thing to do generally. For a 
minimal version at -rc4 time, I believe sticking with 0x80 and 0xed ie best.

Lots of time during .25 to go wild...

Rene.
