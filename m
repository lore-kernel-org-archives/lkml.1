Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbZKYPZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbZKYPZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 10:25:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757664AbZKYPZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 10:25:35 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:61955 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbZKYPZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 10:25:35 -0500
MIME-Version: 1.0
In-Reply-To: <loom.20091125T141518-371@post.gmane.org>
References: <200911222201.59471.linux@rainbow-software.org> 
	<200911231359.54544.rusty@rustcorp.com.au> <s5h8wdxab2h.wl%tiwai@suse.de> 
	<ac3eb2510911230613w5543e98bg4203a1fbd7269931@mail.gmail.com> 
	<loom.20091125T141518-371@post.gmane.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 25 Nov 2009 16:23:23 +0100
Message-ID: <ac3eb2510911250723i20efac2frcb55ec13ab15da6f@mail.gmail.com>
Subject: Re: MODULE_DEVICE_TABLE(isapnp, ...) does nothing
To: Matthieu CASTET <castet.matthieu@free.fr>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 15:42, Matthieu CASTET <castet.matthieu@free.fr> wrote:
> Kay Sievers <kay.sievers <at> vrfy.org> writes:
>>
>> No, we don't even have proper modaliases for the pnp bus
>> (/sys/bus/pnp) and the alias string for pnp in the modules have a
>> broken and unfixable format. PNP autoloading is all handled by the
>> acpi modaliases these days. This is the first time in years I hear
>> anybody asking for hotplug setups of plain old pnp devices. :)
>>
> The naming is really bad. This as nothing to do with acpi : pnp and pnp_cards
> entries are duplicated to another naming. And this should work on system
> without
> acpi.
> This should have been named to pnp2 or something like that.

I don' think there is anything like a second version, it's just that
acpi handles the same pnp ids natively, so we added (non-broken)
matches for it, which works properly on almost all current boxes. If
someone wants to finally fix pnp and get proper modalias working, the
acpi alias generation in the pnp modules can be reverted without
trouble.

> Now I don't see why isapnp_device_id and pnp_card_device_id can't be merged
> together.
>
> For example most of alsa isa card use pnp_card_device_id and not
> isapnp_device_id.

It's just that nobody really cared, I guess. I wouldn't be surprised,
if this is just another round of "discussion" like we had so many
about this topic the past years, and nothing will happen to
pnp/isapnp. :)

Kay
