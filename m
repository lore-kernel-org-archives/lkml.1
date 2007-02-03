Return-Path: <linux-kernel-owner+w=401wt.eu-S1945898AbXBCLyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945898AbXBCLyg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 06:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423217AbXBCLyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 06:54:36 -0500
Received: from thunk.org ([69.25.196.29]:33766 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423216AbXBCLyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 06:54:35 -0500
Date: Sat, 3 Feb 2007 06:54:12 -0500
From: Theodore Tso <tytso@mit.edu>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Bodo Eggert <7eggert@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jon Masters <jonathan@jonmasters.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH/RFC] alternative aproach to: Ban module license tag string termination trick
Message-ID: <20070203115412.GA15419@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Bodo Eggert <7eggert@gmx.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>,
	Jon Masters <jonathan@jonmasters.org>,
	Alexey Dobriyan <adobriyan@gmail.com>
References: <Pine.LNX.4.58.0702022216120.25199@be1.lrz> <Pine.LNX.4.61.0702031213220.27840@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0702031213220.27840@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 03, 2007 at 12:32:08PM +0100, Jan Engelhardt wrote:
> I strongly nak that. If you combine two object files (e.g. foo.o, bar.o)
> that have different licenses, the resulting object file (comb.o) IMHO
> constitutes a combined work, and hence the GPL should be applied to all of
> it. That obviously "does not work" - what good is a GPL comb.o file if you
> don't have the source to bar.o? 

Gaaah.  This is why it's a bad idea to try to attempt to do GPL
"enforcement" in kernel code.  Your reasoning is totally bogus.  GPL
is only about distribution, and if a user is building a standalone
module which they never distibute, the provisions of GPL won't apply,
since it's only about distribution, and a user who builds an ATI or
Nvidia module in the privacy of their own home won't be violating the
GPL.   

						- Ted
