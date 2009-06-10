Return-Path: <linux-kernel-owner+w=401wt.eu-S1758460AbZFJAaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460AbZFJAaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 20:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbZFJA3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 20:29:52 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:61847 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbZFJA3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 20:29:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Jvf87m7j4m9Lar5KW9OeIpSzP4up6YkIIO1CUP2HcVm+XMiIYca37Ai83acxyLNtnS
         jHe/5OC0pVO7nAI1mgbomTsOIwfVLi+8M3c4S+3+OFhtJ0ZwHDcypnMfrl6phDjZE6IC
         2nll4ar30vXUmAr8hdVEcbTX+DQgtyhZ4cC08=
MIME-Version: 1.0
In-Reply-To: <20090610002236.GA19743@srcf.ucam.org>
References: <20090331230217.GA31599@srcf.ucam.org>
	 <20090401165345.GA13939@srcf.ucam.org>
	 <74962ea30904011003o354e8780ya5e9ac1a6a579084@mail.gmail.com>
	 <20090401170708.GA14167@srcf.ucam.org>
	 <74962ea30904011013v5ffa0620y1f1aefa2c84e1ce@mail.gmail.com>
	 <20090602140357.GA13548@srcf.ucam.org>
	 <74962ea30906090942r43d374e7ra00e5056eca040a8@mail.gmail.com>
	 <20090609164529.GA11592@srcf.ucam.org>
	 <74962ea30906091718o274a0968ica61ee7a8d915ed5@mail.gmail.com>
	 <20090610002236.GA19743@srcf.ucam.org>
Date: Tue, 9 Jun 2009 18:29:51 -0600
Message-ID: <74962ea30906091729i3e445de8i7f45ccfe5e9ea234@mail.gmail.com>
Subject: Re: [PATCH 2/2] toshiba-acpi: Support TOS1900-type devices
From: Azael Avalos <coproscefalo@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, dsilvers@simtec.co.uk,
       toshiba_acpi@memebeam.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 9, 2009 at 6:22 PM, Matthew Garrett<mjg59@srcf.ucam.org> wrote:
> On Tue, Jun 09, 2009 at 06:18:59PM -0600, Azael Avalos wrote:
>
>> Indeed an i8042 event pops up, actually dmesg shows the following
>> regardless of the hotkey pressed, even by only pressing the Fn key:
>>
>> atkbd.c: Unknown key released (translated set 2, code 0x6e on isa0060/serio0).
>> atkbd.c: Use 'setkeycodes 6e <keycode>' to make it known.
>
> On press or on release? We could potentially grab that inside
> toshiba_acpi and use that to trigger the poll, but we'd still need to
> clear the value again.

On both actually

> That's kind of ugly. The _Q43 method is clearly
> what should be being executed, so maybe there's another call we can make
> that enables it. I'll dig into your DSDT some more.
>

Cool, hopefully you can find something useful there that I missed,
which by the way, that DSDT is incomplete, I can't compile it w/
Intel's compiler...


Saludos
Azael


-- 
-- El mundo apesta y vosotros apestais tambien --
