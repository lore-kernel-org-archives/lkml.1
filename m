Return-Path: <linux-kernel-owner+w=401wt.eu-S933156AbXFEPy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156AbXFEPy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 11:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932466AbXFEPyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 11:54:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36450 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426AbXFEPyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 11:54:46 -0400
Subject: Re: [Patch 04/18] include/linux/logfs.h
From: David Woodhouse <dwmw2@infradead.org>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, John Stoffel <john@stoffel.org>,
       Willy Tarreau <w@1wt.eu>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       CaT <cat@zip.com.au>, Ondrej Zajicek <santiago@crfreenet.org>,
       linux-kernel@vger.kernel.org, Bill Davidsen <davidsen@tmr.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Thomas Gleixner <tglx@linutronix.de>, Dongjun Shin <djshin90@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Arnd Bergmann <arnd@arndb.de>,
       Albert Cahalan <acahalan@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org,
       Artem Bityutskiy <dedekind@infradead.org>,
       Sam Ravnborg <sam@ravnborg.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>,
       =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       Pavel Machek <pavel@ucw.cz>, Ulisses Furquim <ulissesf@gmail.com>,
       akpm@osdl.org, David Weinehall <tao@acc.umu.se>
In-Reply-To: <18f622d94e9273fe6c93ef091fcec87c@kernel.crashing.org>
References: <20070603183845.GA8952@lazybastard.org>
	 <20070603184205.GE8952@lazybastard.org> <200706032342.27252.arnd@arndb.de>
	 <20070604091245.GF14823@lazybastard.org>
	 <1180964303.25232.358.camel@pmac.infradead.org>
	 <18f622d94e9273fe6c93ef091fcec87c@kernel.crashing.org>
Content-Type: text/plain
Date: Tue, 05 Jun 2007 16:53:55 +0100
Message-Id: <1181058836.16089.23.camel@hades.cambridge.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-2.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-05 at 17:49 +0200, Segher Boessenkool wrote:
> > It would be better if GCC had a 'nopadding' attribute which gave us 
> > what we need without the _extra_ implications about alignment.
> 
> That's impossible; removing the padding from a struct
> _will_ make accesses to its members unaligned (think
> about arrays of that struct).

It _might_ make accesses to _some_ of its members unaligned.

That's why I said 'without the __EXTRA__ implications about alignment'. 

Obviously the lack of padding has its own implications, but we don't
necessarily need to assume that the struct may be at arbitrary
locations.

-- 
dwmw2

