Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbZCIRMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbZCIRMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 13:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbZCIRMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 13:12:12 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:53068 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbZCIRMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 13:12:10 -0400
Date: Mon, 09 Mar 2009 13:11:56 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Richard Hughes <hughsient@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, hal@lists.freedesktop.org
Subject: Re: [PATCH] toshiba_acpi: Add full hotkey support
In-reply-to: <15e53e180903080033h5e990f08o3622afae018c38ca@mail.gmail.com>
Message-id: <alpine.LFD.2.00.0903091307200.16491@localhost.localdomain>
References: <20090306003941.GA32403@srcf.ucam.org>
 <E1LfqwF-000B1G-00.arvidjaar-mail-ru@mx3.mail.ru>
 <20090307150640.GA3516@srcf.ucam.org>  <200903071839.16508.arvidjaar@mail.ru>
 <20090307154424.GA3909@srcf.ucam.org>
 <15e53e180903071219q4ed318edt2fa8f492426c0ab6@mail.gmail.com>
 <20090307202647.GA9776@srcf.ucam.org>
 <15e53e180903080033h5e990f08o3622afae018c38ca@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Mar 2009, Richard Hughes wrote:

> On Sat, Mar 7, 2009 at 8:26 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > On Sat, Mar 07, 2009 at 08:19:51PM +0000, Richard Hughes wrote:
> >
> >> Mapping KEY_SUSPEND to hibernate is just insane. Can you please change
> >> the toshiba driver to use KEY_HIBERNATE and KEY_SUSPEND as thinkpad
> >> now does? Thanks.
> >
> > Mapping KEY_SUSPEND to hibernate is what we've been doing for years.
> > It's what hal *still does*.
> 
> Sure, but how much userspace now listens to HAL for these events? Xorg
> and evdev has taken over that role for all the session. We can ship a
> trivial patch as an fdi file to HAL to remap this if required.
> 
> > KEY_SLEEP has been the suspend to RAM key forever.
> 
> Except if you're a USB keyboard. Grep through the kernel sources and
> see how many drivers get this wrong. We can't map three sleep states
> to two buttons in any sane way. For instance, is the sleep acpi button
> supposed to trigger a suspend of hibernate? Surely this is user policy
> as it is not specified on the the exterior of the machine.

While hot-keys are totally platform dependent and non-standard,
the ACPI spec does describe the power and sleep button.

Unfortunately, it doesn't answer this question for us --
stating that the sleep button enters G1, which can be
any of S1-S4.

Len Brown, Intel Open Source Technology Center
