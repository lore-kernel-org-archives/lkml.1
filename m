Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbZIKImE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbZIKImE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 04:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbZIKImD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 04:42:03 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59557 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753323AbZIKImC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 04:42:02 -0400
Date: Fri, 11 Sep 2009 09:43:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Alan Cox <alan@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] char/tty_io: fix legacy pty name when more than 256 pty
 devices are requested
Message-ID: <20090911094310.23126814@lxorguk.ukuu.org.uk>
In-Reply-To: <4AA92487.5080401@zytor.com>
References: <20090908144942.76ddf0e7@caramujo.chehab.org>
	<4AA6DF50.3030603@zytor.com>
	<20090908203323.486c129c@caramujo.chehab.org>
	<4AA6F63F.7090009@zytor.com>
	<20090908235441.04549a29@caramujo.chehab.org>
	<4AA73309.8030302@zytor.com>
	<20090910010512.60a1f523@caramujo.chehab.org>
	<4AA89B02.1050909@zytor.com>
	<20090910093301.4ccfd786@caramujo.chehab.org>
	<20090910150716.66310f02@lxorguk.ukuu.org.uk>
	<4AA92487.5080401@zytor.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> hardly significant in the namespace pollution sense.  Can you imagine
> ttyp1 being a BSD pty and ttyp10 being a completely different kind of
> device?

No but I can imagine

		ttyp1

		ttypr0
		ttypr1

being different devices (and we have upper case examples of that where
single case is running tight now)

Anyway, we don't need over 256 BSD pty devices and the libraries can't do
it so I still believe its a waste of electrons
