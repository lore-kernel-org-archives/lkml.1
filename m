Return-Path: <linux-kernel-owner+w=401wt.eu-S1761404AbXJYW6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761404AbXJYW6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 18:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbXJYW6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 18:58:40 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:60806 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbXJYW6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 18:58:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Vp8Dc5hBGnD0TtA2+ypH24xHk2rAh29umB7Iuv6/Nm5GWlOG6c6gqGbWoXpKSSOVYE2L84k2p0fAtK6lxWq3G+HAEIVNc0O1SR8uGkVb5w1JeQG2go114EAUYsMF9QqII+2Ru+jiZsMxF1/echTEJqTAweuOFNjwj41ZfcUVfLI=
Message-ID: <fc94aae90710251558o36fc1be7nd20d515f4831a49d@mail.gmail.com>
Date: Thu, 25 Oct 2007 23:58:36 +0100
From: "Michael Lothian" <mike@fireburn.co.uk>
To: "Adrian Bunk" <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Possibility of adding -march=native to x86
In-Reply-To: <20071025222826.GY30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071025185022.GP30533@stusta.de>
	 <20071025191723.GQ30533@stusta.de>
	 <fc94aae90710251232m117421e7ref3e5a6270ff25d2@mail.gmail.com>
	 <20071025195020.GS30533@stusta.de>
	 <fc94aae90710251312w2eba46e8h5d4f8715ad0e91b6@mail.gmail.com>
	 <4720FF2B.9020802@googlemail.com>
	 <fc94aae90710251430s669418e5v72282ff5f8a5691e@mail.gmail.com>
	 <20071025214647.GX30533@stusta.de>
	 <fc94aae90710251518l1cc129eahf570177e5b516197@mail.gmail.com>
	 <20071025222826.GY30533@stusta.de>
X-Google-Sender-Auth: ff517e212f6f94fb
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Half the time it's easier doing a lsmod when booted on a livecd and
> > trying to figure out what options are required from the module names
> > which sometime can be just as tricky.
>
> Sure, distributions already have solved this and you can use their
> work.

I like compiling my own kernel it's just a pain doing it the first
time on a new motherboard or when adding a new piece of hardware

> > Maybe even having a make addnewhardware option to quickly add extra
> > devices to your config file.
>
> Knowing your CPU is much easier to figure out than to figure out the
> BIOS settings of your SATA controller that determine how to access it.

So how do distro's figure out which driver to use? Isn't it a matter
of taking the pci-ids and selecting the correct driver?

> If you do not even know what CPU you have you should really not compile
> your own kernel.

It about ease of use, look at the new core2 architecture, if your gcc
is new enough there is a march=core2 else you use an older flag

Same with the new cell architecture you use cell if your using gcc 4.3
alpha or 930 if it's not that new.

What I'm saying is sometimes GCC or the Kernel is better at making
these decisions or at least make it easier

Mike
