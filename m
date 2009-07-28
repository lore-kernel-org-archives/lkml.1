Return-Path: <linux-kernel-owner+w=401wt.eu-S1754402AbZG1PHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbZG1PHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbZG1PHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:07:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33587 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754153AbZG1PH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:07:29 -0400
Date: Tue, 28 Jul 2009 16:07:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: alsa-devel@alsa-project.org, Jonathan McDowell <noodles@earth.li>,
       Tony Lindgren <tony@atomide.com>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       e3-hacking@earth.li, Arun KS <arunks@mistralsolutions.com>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [alsa-devel] [RFC] [PATCH 1/3] ASoC: Add support for Conexant
 CX20442-11 voice modem codec
Message-ID: <20090728150727.GA10870@rakim.wolfsonmicro.main>
References: <200907220522.29221.jkrzyszt@tis.icnet.pl>
 <20090722101027.GA7622@sirena.org.uk>
 <200907281659.36000.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907281659.36000.jkrzyszt@tis.icnet.pl>
X-Cookie: Happy feast of the pig!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 04:59:33PM +0200, Janusz Krzysztofik wrote:

> Following that model, the line discipline code didn't seam to belong to a 
> codec driver for me. If it could be recognized as a new bus dirver, it should 
> be pushed down probably into a separate module. However, if it was rather 
> some kind of a bus adapter driver, it seamed to belong to the machine code.

The way it looks with the current code the line discipline itself is
going to apply equally well to any serial port that's used - I'm not
clear what's system-specific about it.  The bit that connects the line
discipline to the line is a different matter but the bit that interacts
with the TTY layer after registration is working through a pluggable
abstraction layer and shouldn't, I'd expect, be specific to the
particular serial port.
