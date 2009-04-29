Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbZD2KF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbZD2KF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755976AbZD2KFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:05:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42185 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756798AbZD2KFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:05:41 -0400
Date: Wed, 29 Apr 2009 12:05:40 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Ulrich Dangel <uli@spamt.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: Fix the support for apple mini aluminium keyboard
Message-ID: <alpine.LNX.2.00.0904291205210.5012@wotan.suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009, Ulrich Dangel wrote:

> Quirks for the apple mini keyboard was recently added but keyboard
> was recognized as a powerbook keyboard. Adjusted boundary to the lowest
> product id for the apple mini keyboard to get the right translation.
> 
> Signed-off-by: Ulrich Dangel <uli@spamt.net>
> ---
>  drivers/hid/hid-apple.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
> index 7359d9d..acbce57 100644
> --- a/drivers/hid/hid-apple.c
> +++ b/drivers/hid/hid-apple.c
> @@ -151,7 +151,7 @@ static int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
>  	if (fnmode) {
>  		int do_translate;
>  
> -		trans = apple_find_translation((hid->product < 0x220 ||
> +		trans = apple_find_translation((hid->product < 0x21d ||
>  					hid->product >= 0x300) ?
>  					powerbook_fn_keys : apple_fn_keys,
>  					usage->code);

Applied, thanks Ulrich.

-- 
Jiri Kosina
SUSE Labs
