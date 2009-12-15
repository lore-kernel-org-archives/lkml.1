Return-Path: <linux-kernel-owner+w=401wt.eu-S933862AbZLOWq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933862AbZLOWq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 17:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbZLOWqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:46:24 -0500
Received: from smtp12.ono.com ([62.42.230.20]:22487 "EHLO resmaa12.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932735AbZLOWqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:46:22 -0500
Date: Tue, 15 Dec 2009 23:46:19 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Useless thermal acpi driver ?
Message-ID: <20091215234619.62d0ebc1@werewolf.home>
In-Reply-To: <alpine.LFD.2.00.0912142159540.9446@localhost.localdomain>
References: <20091209232608.25aed4ca@werewolf.home>
	<4B20483C.6090309@gmail.com>
	<alpine.LFD.2.00.0912110122570.24891@localhost.localdomain>
	<20091211094515.4b4872ef@werewolf.home>
	<alpine.LFD.2.00.0912142159540.9446@localhost.localdomain>
X-Mailer: Claws Mail 3.7.3cvs35 (GTK+ 2.19.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009 22:00:25 -0500 (EST), Len Brown <lenb@kernel.org> wrote:

> this DSDT returns a constant temperature, always:
> 
>             Method (_TMP, 0, NotSerialized)
>             {
>                 Return (0x0BB8)
>             }
> 
> 
> so in this case, Linux is just reporting the (lack of) news:-)
> 

So, lets see...:

- Someone decided ACPI is the only-real-good-way
- Only a few devices are ported to ACPI
- The old way is unusable
- We can not return to the old way

So, any solution ? Thermal ACPI info in this boards (and I suspect in many
others) is useless. We can not disable that part of ACPI, we can not enable
sensors. So no thermal monitoring.
Nice.

Ayways, as in this case the ACPI part does not any real work, is still
present the problem of two drivers poking the same hardware or could I use
that 'lax' trick ?

And second, can the traditional sensor drivers be ported to offer an ACPI
device replacing the default one, or is that a stupid question ?

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2010.0 (Cooker) for x86_64
Linux 2.6.29.3-desktop-1mnb (gcc 4.3.2 (GCC) #1 Wed May
