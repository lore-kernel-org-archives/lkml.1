Return-Path: <linux-kernel-owner+w=401wt.eu-S1752769AbXIRXZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbXIRXZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 19:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757622AbXIRXYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 19:24:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35536 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757493AbXIRXYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 19:24:50 -0400
Date: Tue, 18 Sep 2007 16:23:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shentino <shentino@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@suse.cz>,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: BUG? Suspend during active sound playback kills sound
Message-Id: <20070918162343.eaea094c.akpm@linux-foundation.org>
In-Reply-To: <70513aa50709181606n3cb5f5d2k5ab4e8f8b7c145ac@mail.gmail.com>
References: <70513aa50709181606n3cb5f5d2k5ab4e8f8b7c145ac@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 16:06:21 -0700
Shentino <shentino@gmail.com> wrote:

> Run any program that opens the ALSA sound (and probably the dsp
> legacy), and then suspend to disk during playback.
> 
> On the next and each subsequent thawout, the sound is dead even if you
> close and repoen the sound.  Only a "cold boot" can fix it.

Which kernel version, which sound driver and what type of sound card?

Thanks.
