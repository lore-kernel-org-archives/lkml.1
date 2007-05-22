Return-Path: <linux-kernel-owner+w=401wt.eu-S1760665AbXEVJFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760665AbXEVJFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 05:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755687AbXEVJE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 05:04:56 -0400
Received: from ku-gbr.de ([81.3.11.18]:46074 "EHLO ku-gbr.de"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755571AbXEVJEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 05:04:55 -0400
X-Greylist: delayed 2010 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 May 2007 05:04:55 EDT
Date: Tue, 22 May 2007 10:30:53 +0200
From: Konstantin Kletschke <lists@ku-gbr.de>
To: linux-kernel@vger.kernel.org
Subject: Re: 8250_pnp is confused... (udev?)
Message-ID: <20070522083052.GA2779@z1.synertronixx>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <46528811.2010302@cyte.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46528811.2010302@cyte.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2007-05-21 23:05 -0700 schrieb Jeff Wiegley:
> I've used serial ports a lot in the past but not for the
> past year so. Did something fundamental change?

I use a serial PCI adaptor:

00:0b.0 Serial controller: NetMos Technology PCI 9835 Multi-I/O
Controller (rev 01)

Well, I have also not used ttyS2 for a while and recently I realized, it
does not like, when I past with a mouse a line into any terminal with a
line break (Input Output Error). ttyS1 (same card) works fine.

> and things are quite weird... I get all of the /dev/ttyS's
> that I DON'T have and none of the ones that I do!

When I have 8250* build as modules I get:

ttyS0: OnBoard
ttyS1: PCI card, first Port
ttyS3: bogus, could have been meant to become ttyS2, second Port.

So there is weird stuff going on since recent Kernel versions. May be
since 2.6.19 until 2.6.21 (As said, I did not use the ttyS2 for a
while).

Konsti


-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF
