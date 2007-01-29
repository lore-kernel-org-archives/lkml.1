Return-Path: <linux-kernel-owner+w=401wt.eu-S933251AbXA2HAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933251AbXA2HAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 02:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933248AbXA2HAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 02:00:30 -0500
Received: from smtp.osdl.org ([65.172.181.24]:51913 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933247AbXA2HA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 02:00:29 -0500
Date: Sun, 28 Jan 2007 22:48:34 -0800
From: Andrew Morton <akpm@osdl.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Uwe Bugla <uwe.bugla@gmx.de>, Adrian Bunk <bunk@stusta.de>,
       torvalds@linux-foundation.org, rml@novell.com, ttb@tentacle.dhs.org,
       nickpiggin@yahoo.com.au, cijoml@volny.cz, linuxppc-dev@ozlabs.org,
       anton@samba.org, paulus@samba.org, livio@eecg.toronto.edu,
       petero2@telia.com, hch@lst.de, gd@spherenet.de,
       alan@lxorguk.ukuu.org.uk, linux-ide@vger.kernel.org,
       B.Zolnierkiewicz@elka.pw.edu.pl, linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6: known unfixed regressions (v2) (part 2)
Message-Id: <20070128224834.37482553.akpm@osdl.org>
In-Reply-To: <1170051963.6454.7.camel@Homer.simpson.net>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
	<20070127174230.GN6017@stusta.de>
	<20070128133344.214070@gmx.net>
	<1170051963.6454.7.camel@Homer.simpson.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007 07:26:03 +0100
Mike Galbraith <efault@gmx.de> wrote:

> FWIW, I just tried it with 2.6.20-rc6, and can confirm.  Once nero is
> run, the kernel never gives up retrying whatever command failed, so I
> get...
> 
> [ 4362.972995] hdd: status error: status=0x58 { DriveReady SeekComplete
> DataRequest }
> [ 4362.981475] ide: failed opcode was: unknown
> [ 4362.986183] hdd: drive not ready for command
> 
> endlessly.

Do you have time to bisect it?
