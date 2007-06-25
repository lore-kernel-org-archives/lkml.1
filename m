Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbXFYRNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbXFYRNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 13:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750718AbXFYRN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 13:13:27 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:33478 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751027AbXFYRN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 13:13:26 -0400
Date: Mon, 25 Jun 2007 13:13:25 -0400
To: Tomasz K?oczko <kloczek@rudy.mif.pg.gda.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Message-ID: <20070625171325.GA31195@csclub.uwaterloo.ca>
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl> <20070625144439.GI10008@csclub.uwaterloo.ca> <Pine.BSO.4.63.0706251742320.25800@rudy.mif.pg.gda.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.BSO.4.63.0706251742320.25800@rudy.mif.pg.gda.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 05:48:21PM +0200, Tomasz K?oczko wrote:
> On Mon, 25 Jun 2007, Lennart Sorensen wrote:
> [..]
> >In my experience OSS is a pile of crap compared to ALSA.
> 
> Could you say something more detailed about this compare ?

Well the last time I bothered to look at OSS, it was still stuck at
supproting stereo only.  It believed that if a card supported SB
emulation, then adding support for that was good enough.  it also
thought supporting the GUS PnP through emulation of the original GUS
counted as support.  Essentially it was all about having a long list of
supported chips, where support simply meant it could make some sounds,
and if you were lucky it might even do stereo.  At the time ALSA was
already far beyond that in supporting all the inputs and outputs of many
cards, supporting their true native capabilities, rather than some
mediocre emulation mode.  The fact ALSA was open source sure didn't hurt
either.

OSS being willing to sign NDAs also didn't help the rest of the linux
community in any way when it came to trying to get hardware makers to
release specs so drivers could actually be written for inclusion in the
kernel.

--
Len Sorensen
