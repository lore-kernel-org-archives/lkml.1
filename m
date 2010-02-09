Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab0BIKRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 05:17:48 -0500
Received: from cantor.suse.de ([195.135.220.2]:40764 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab0BIKRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 05:17:46 -0500
Date: Tue, 9 Feb 2010 11:17:44 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "L.P. White" <lpw25@cam.ac.uk>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: Add mapping for "AL Network Chat" usage
In-Reply-To: <Prayer.1.3.2.1002081302050.29006@hermes-2.csi.cam.ac.uk>
Message-ID: <alpine.LNX.2.00.1002091117070.30967@pobox.suse.cz>
References: <Prayer.1.3.2.1002081302050.29006@hermes-2.csi.cam.ac.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Feb 2010, L.P. White wrote:

> From: Leo P White <lpw25@cam.ac.uk>
> 
> Adding a mapping for the 'AL Network Chat' usage from the 'Consumer' usage
> page (USB HID Usage Tables v1.11). This usage is used by some keyboards for a
> multimedia key.
> 
> Signed-off-by: Leo P White <lpw25@cam.ac.uk>
> 
> ---
> 
> diff -upNr linux.orig/drivers/hid/hid-input.c
> linux.new/drivers/hid/hid-input.c --- linux.orig/drivers/hid/hid-input.c
> 2010-02-06 22:17:12.000000000 +0000 +++ linux.new/drivers/hid/hid-input.c
> 2010-02-08 12:32:13.005554190 +0000 @@ -400,6 +400,7 @@ static void
> hidinput_configure_usage(str
> 		case 0x192: map_key_clear(KEY_CALC);		break;
> 		case 0x194: map_key_clear(KEY_FILE);		break;
> 		case 0x196: map_key_clear(KEY_WWW);		break;
> +		case 0x199: map_key_clear(KEY_CHAT);		break;
> 		case 0x19c: map_key_clear(KEY_LOGOFF);		break;
> 		case 0x19e: map_key_clear(KEY_COFFEE);		break;
> 		case 0x1a6: map_key_clear(KEY_HELP);		break;

Thanks for the patch. It has been line-wrapped and whitespace-damaged.

I have fixed it up by hand on my end and applied it, but please keep that 
in mind for you future patch submissions.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
