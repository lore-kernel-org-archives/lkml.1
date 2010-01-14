Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288Ab0ANSIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab0ANSIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 13:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866Ab0ANSIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 13:08:43 -0500
Received: from khc.piap.pl ([195.187.100.11]:58373 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab0ANSIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 13:08:42 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: SATA_SIL on IXP425 workaround
References: <m33a4nfvva.fsf@intrepid.localdomain>
	<201001141659.19687.bzolnier@gmail.com>
Date: Thu, 14 Jan 2010 19:08:39 +0100
In-Reply-To: <201001141659.19687.bzolnier@gmail.com> (Bartlomiej
	Zolnierkiewicz's message of "Thu, 14 Jan 2010 16:59:19 +0100")
Message-ID: <m3y6k0h848.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> writes:

> FWIW your patch is now in my atang tree (I'm aware that Jeff is working
> on generic solution but in the meantime this non-intrusive patch allows
> sata_sil to work on IXP425).

Thanks. BTW I could help with the "general solution", but I wonder if
what we need is simply adding those other ARM archs to IXP4xx (through
Kconfig)? If they have the same problem, namely inability to do
readb/readw only, while being able to write[bwl] and all kinds of non-MM
I/O.

writeb() is important since it starts the "large PRD" transfers (it has
to use MMIO BAR to be "large").
-- 
Krzysztof Halasa
