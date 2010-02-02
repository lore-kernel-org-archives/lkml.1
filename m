Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab0BBVoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 16:44:39 -0500
Received: from cantor.suse.de ([195.135.220.2]:38303 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754747Ab0BBVog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 16:44:36 -0500
Date: Tue, 2 Feb 2010 22:44:35 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Peter Hutterer <peter.hutterer@who-t.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: add multi-input quirk for eGalax Touchcontroller
In-Reply-To: <20100202034040.GA16880@barra.bne.redhat.com>
Message-ID: <alpine.LNX.2.00.1002022129380.15395@pobox.suse.cz>
References: <20100202034040.GA16880@barra.bne.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Feb 2010, Peter Hutterer wrote:

> Nonetheless, I'm not sure about whether that's the right thing to do. With
> this patch applied, it gives me two devices, one mute, the other one
> announces BTN_PEN and BTN_TOUCH + abs axes, though only BTN_TOUCH is ever
> triggered. Loading usbtouchscreen instead of usbhid for this device makes
> the device look more sane BTN_TOUCH + abs axes but the actual data is
> random. So I'm not quite sure what the fix is supposed to be, any hints are
> appreciated if it's not the patch below.

The data could also be mis-interpreted because of some bug in the HID 
descriptor.

Does looking at the HID report descriptor and looking at the actual 
raw HID reports coming out from the device give any clue? (in recent 
kernels, you can just use 'hid' directory in debugfs to gather all this 
information).

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
