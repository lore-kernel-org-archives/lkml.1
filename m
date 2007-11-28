Return-Path: <linux-kernel-owner+w=401wt.eu-S1759548AbXK1JC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548AbXK1JC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 04:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbXK1JC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 04:02:28 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38381 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755533AbXK1JC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 04:02:26 -0500
Date: Wed, 28 Nov 2007 01:00:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
       Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org
Subject: Re: m68k build failure
Message-Id: <20071128010056.85703a34.akpm@linux-foundation.org>
In-Reply-To: <20071128094856.056c0a3f@poseidon.drzeus.cx>
References: <20071127220723.e2e3d0b4.akpm@linux-foundation.org>
	<20071128094856.056c0a3f@poseidon.drzeus.cx>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007 09:48:56 +0100 Pierre Ossman <drzeus@drzeus.cx> wrote:

> On Tue, 27 Nov 2007 22:07:23 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > Current Linus tree give me this, with m68k allmodconfig:
> > 
> > FATAL: drivers/bluetooth/btsdio: sizeof(struct sdio_device_id)=12 is not a modulo of the size of section __mod_sdio_device_table=30.
> > Fix definition of struct sdio_device_id in mod_devicetable.h
> > 
> > which I haven't seen before.  Any ideas?
> > 
> 
> No the slightest. 12 seems like the correct, padded size. A size of 10 is just weird as the unpadded size is 9 bytes. Could you dump the __mod_sdio_device_table section so we can determine if it is cropped or just oddly padded.
> 

err, I'd rather not.  I have no shortage of bugs to be going on with here.

http://userweb.kernel.org/~akpm/cross-compilers/ has the i386->m68k
cross-compiler which I use.

