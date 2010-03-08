Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab0CHKbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 05:31:16 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:50985 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab0CHKbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 05:31:13 -0500
Date: Mon, 8 Mar 2010 11:31:08 +0100
From: Daniel Mack <daniel@caiaq.de>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: dave b <db.pub.mail@gmail.com>, linux-arm-kernel@lists.infradead.org,
       Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Subject: Re: weirdness with compiling a 2.6.33 kernel on arm debian
Message-ID: <20100308103108.GF28972@buzzloop.caiaq.de>
References: <25ae2d691003051958x72040b47g29d842f1d389a6cf@mail.gmail.com>
 <19346.6765.457769.167118@pilspetsen.it.uu.se>
 <25ae2d691003060224x67ab1c9au5102c8a22518aff@mail.gmail.com>
 <20100306104131.GV28972@buzzloop.caiaq.de>
 <25ae2d691003061705l5fc0bca7n4a07f558a0c410cf@mail.gmail.com>
 <20100308095337.GB27502@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100308095337.GB27502@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 08, 2010 at 10:53:37AM +0100, Uwe Kleine-König wrote:
> On Sun, Mar 07, 2010 at 12:05:21PM +1100, dave b wrote:
> > Ok... however how should one test the memory of an arm machine? ...
> > memtest is only for x86. *I am referring to the kernel memtest and not
> > memtest86.
> The easiest is:  rerun make and check if it fails at exactly the same
> place.

Hmm, I wonder whether this is in any way related to what Pavel and Cyril
reported in the 'bit error' thread.

Dave, does your bootloader have any memory test built-in? Do you see the
same issues with any older kernel?

FWIW, we're currently hunting a strange bug with hanging tasks, which
only seems to affect systems with Wifi enabled. That might be totally
unrelated to both of these issues though.

Daniel
