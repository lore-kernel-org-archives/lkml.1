Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbZLCJwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbZLCJwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 04:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbZLCJwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 04:52:25 -0500
Received: from cantor.suse.de ([195.135.220.2]:44366 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbZLCJwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 04:52:24 -0500
Date: Thu, 3 Dec 2009 10:52:29 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Peter Hutterer <peter.hutterer@redhat.com>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: add multi-input quirk for NextWindow Touchscreen.
In-Reply-To: <20091203050810.GA26595@barra.bne.redhat.com>
Message-ID: <alpine.LNX.2.00.0912031052160.3755@pobox.suse.cz>
References: <20091203050810.GA26595@barra.bne.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Dec 2009, Peter Hutterer wrote:

> These touchscreens are mounted onto HP TouchSmart and the Dell Studio One
> 19. Without a quirk they report a wrong button set and the x/y coordinates
> through ABS_Z/ABS_RX, confusing the higher levels (most notably X.Org's
> evdev driver).
> 
> Device id 0x003 covers models 1900, 2150, and 2700 [1] though testing could
> only be performed on a model 1900.
> 
> [1] http://www.nextwindow.com/nextwindow_support/latest_tech_info.html
> 
> Signed-off-by: Peter Hutterer <peter.hutterer@redhat.com>
> ---
>  drivers/hid/hid-ids.h           |    3 +++
>  drivers/hid/usbhid/hid-quirks.c |    1 +
>  2 files changed, 4 insertions(+), 0 deletions(-)

Applied, thanks Peter.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
