Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbZANIYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbZANIYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 03:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756517AbZANIXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 03:23:52 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:42449 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755655AbZANIXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 03:23:51 -0500
Message-ID: <496DA0FF.2060206@knaff.lu>
Date: Wed, 14 Jan 2009 09:23:27 +0100
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: The policy on initramfs decompression failure
References: <496D17F9.8080605@zytor.com> <496D20FB.5010307@knaff.lu> <20090114054022.GA11153@elte.hu> <496D8E0D.5090401@knaff.lu> <20090114074852.GB16274@elte.hu>
In-Reply-To: <20090114074852.GB16274@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Alain Knaff <alain@knaff.lu> wrote:
> 
>> Ingo Molnar wrote:
>>> And your argument makes little sense: if there is something wrong then one 
>>> looks at the logs _anyway_.
>> Unfortunately, not everybody has the knowledge or equipment ready to set
>> up a serial console... [...]
> 
> By your argument the ton of warnings we emit in various situations are 
> wrong too and all should be panic()s.

That is not my argument. I never said something like that.

I don't know, but I have to wonder about the strength of _your_ position if
the only way to defend it is to put words into other people's mouth.

> That argument is bogus.

Indeed that argument is bogus. However, I'm not sure where it is coming from...

> Not looking at the logs makes boot problem analysis harder of course. Nor 
> is your argument actually true: you can use printk_delay or any other 
> method.

This is interesting information. Where can I find documentation about this?
Neither google, nor a find-grep in the kernel sources turned up anything
useful...

> Or you can use the VGA console and use shift-pageup ...

No you can't. Try it. Or is this only a kvm artifact?

> 
> 	Ingo

Alain
