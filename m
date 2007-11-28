Return-Path: <linux-kernel-owner+w=401wt.eu-S1758322AbXK1J7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322AbXK1J7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 04:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758052AbXK1J6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 04:58:49 -0500
Received: from cantor.suse.de ([195.135.220.2]:38899 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757554AbXK1J6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 04:58:48 -0500
From: Andreas Schwab <schwab@suse.de>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Sam Ravnborg <sam@ravnborg.org>, Marcel Holtmann <marcel@holtmann.org>,
       linux-kernel@vger.kernel.org
Subject: Re: m68k build failure
References: <20071127220723.e2e3d0b4.akpm@linux-foundation.org>
	<20071128094856.056c0a3f@poseidon.drzeus.cx>
X-Yow: YOW!  I can see 1987!!  PRESIDENT FORD is doing the REMAKE of "PAGAN
 LOVE SONG"...he's playing ESTHER WILLIAMS!!
Date: Wed, 28 Nov 2007 10:58:45 +0100
In-Reply-To: <20071128094856.056c0a3f@poseidon.drzeus.cx> (Pierre Ossman's
	message of "Wed\, 28 Nov 2007 09\:48\:56 +0100")
Message-ID: <jeve7m3d4a.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman <drzeus@drzeus.cx> writes:

> On Tue, 27 Nov 2007 22:07:23 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> 
>> Current Linus tree give me this, with m68k allmodconfig:
>> 
>> FATAL: drivers/bluetooth/btsdio: sizeof(struct sdio_device_id)=12 is not a modulo of the size of section __mod_sdio_device_table=30.
>> Fix definition of struct sdio_device_id in mod_devicetable.h
>> 
>> which I haven't seen before.  Any ideas?
>> 
>
> No the slightest. 12 seems like the correct, padded size. A size of 10 is just weird as the unpadded size is 9 bytes. Could you dump the __mod_sdio_device_table section so we can determine if it is cropped or just oddly padded.

A size of 10 is correct.  On m68k no type is aligned to more than 2
bytes.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
