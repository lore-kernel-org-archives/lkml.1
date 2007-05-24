Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbXEXUKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbXEXUKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753210AbXEXUJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:09:58 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753195AbXEXUJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:09:57 -0400
Date: Thu, 24 May 2007 13:09:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Uwe Bugla" <uwe.bugla@gmx.de>
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@suse.cz>,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: BUG in 2.6.22-rc2-mm1: Parts of Alsa sound architecture broken
Message-Id: <20070524130921.8dbd3777.akpm@linux-foundation.org>
In-Reply-To: <20070524200052.234330@gmx.net>
References: <20070524200052.234330@gmx.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 22:00:52 +0200
"Uwe Bugla" <uwe.bugla@gmx.de> wrote:

> Hi everybody,
> 
> with 2.6.22-rc2-mm1 I do get sound out of my machine using snd-intel8x0 module, BUT:
> 
> At least parts of that Alsa sound architecture do seem to be broken:

I assume you're referring to this stuff?

> snd_seq_device: Unknown symbol snd_iprintf
> snd_seq_device: Unknown symbol snd_device_new
> snd_rawmidi: Unknown symbol snd_info_register
> snd_rawmidi: Unknown symbol snd_seq_device_new
> snd_rawmidi: Unknown symbol snd_info_free_entry

Probably some silly missing dependency.  Please send the .config, thanks.
