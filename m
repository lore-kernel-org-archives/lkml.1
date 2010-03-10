Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab0CJNH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:07:57 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:51216 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab0CJNHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:07:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CdVG+OYyLmRVpbULTG/QyUj03mx5WWqdkIEHW0W+OWPWgwPlIOdIEX3qtASIVt5LOW
         T9kFQ4k84JJ+UKjxFtp5Jm1ATCidylxyzhGQLGVBj7Ux2WqOXGe/xnYkU993Y012dYFo
         a8pMJI3yNs1FF7Mabw3X794ly4UlG9Y3zQI48=
MIME-Version: 1.0
In-Reply-To: <b637ec0b1003091458j67efc62cg2c975e9e286f4b0b@mail.gmail.com>
References: <b637ec0b1003091458j67efc62cg2c975e9e286f4b0b@mail.gmail.com>
Date: Wed, 10 Mar 2010 14:07:52 +0100
Message-ID: <71cd59b01003100507q79878fdan98e53cb4e705d2c2@mail.gmail.com>
Subject: Re: Possible bug in eeepc-laptop.c - EeePC 900
From: Corentin Chary <corentin.chary@gmail.com>
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: ACPI mailing list <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 9, 2010 at 11:58 PM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
> Hi.
> I have an EeePC 900 running 2.6.34-rc1.
>
> If I boot it on AC the cpu runs at full speed, 900MHz; if I boot it on
> battery it runs only at 630Mhz. Plugging / unplugging the AC does not
> change the cpu frequency. Only a reboot can change the situation.
>
> I already tried to echo 0 or 1 to the
> /sys/devices/platform/eeepc/cpufv file; no effects, even if the file
> changes its value.
>
> This is not a regression from 2.6.33: this behavior is also present in
> that version.
>
> Does this ring any bells? This is really annoying, especially when
> trying to watch a movie on battery. Also 3D apps show a 30%
> performance drop, as expected.

Can you change the frequency with cpufreq ?
Did you try all cpufv values (see cpufv_available file) ?
Is you bios up-to-date ?

-- 
Corentin Chary
http://xf.iksaif.net
