Return-Path: <linux-kernel-owner+w=401wt.eu-S1758737AbYDATU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737AbYDATU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 15:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756131AbYDATUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 15:20:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751922AbYDATUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 15:20:16 -0400
Date: Tue, 1 Apr 2008 12:20:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@suse.cz>
Cc: perex@perex.cz, linux-kernel@vger.kernel.org, tiwai@suse.de
Subject: Re: usb audio: Fix another Dallas quirk
Message-Id: <20080401122000.83ce5a3e.akpm@linux-foundation.org>
In-Reply-To: <20080329223241.GA5348@elf.ucw.cz>
References: <20080329223241.GA5348@elf.ucw.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Mar 2008 23:32:41 +0100
Pavel Machek <pavel@suse.cz> wrote:

> 
> Dallas USB speakers are buggy in more than one way. One of configs
> they offer does not work at all.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> diff --git a/sound/usb/usbaudio.c b/sound/usb/usbaudio.c
> index 257a4e1..b6b2490 100644
> --- a/sound/usb/usbaudio.c
> +++ b/sound/usb/usbaudio.c
>  	int format;
>  	struct audioformat *fp;
>  	unsigned char *fmt, *csep;
> +	int num;

This is not a patch - something munched the "@@ -2676,12 +2676,23 @@"
line.

I typed it in again.
